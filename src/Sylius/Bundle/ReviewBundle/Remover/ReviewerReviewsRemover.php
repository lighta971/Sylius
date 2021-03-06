<?php

/*
 * This file is part of the Sylius package.
 *
 * (c) Paweł Jędrzejewski
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Sylius\Bundle\ReviewBundle\Remover;

use Doctrine\Common\Persistence\ObjectManager;
use Sylius\Bundle\ResourceBundle\Doctrine\ORM\EntityRepository;
use Sylius\Component\Review\Calculator\ReviewableRatingCalculatorInterface;
use Sylius\Component\Review\Model\ReviewableInterface;
use Sylius\Component\Review\Model\ReviewerInterface;
use Sylius\Component\Review\Model\ReviewInterface;

/**
 * @author Grzegorz Sadowski <grzegorz.sadowski@lakion.com>
 */
class ReviewerReviewsRemover implements ReviewerReviewsRemoverInterface
{
    /**
     * @var EntityRepository
     */
    private $reviewRepository;

    /**
     * @var ObjectManager
     */
    private $reviewManager;

    /**
     * @var ReviewableRatingCalculatorInterface
     */
    private $averageRatingCalculator;

    /**
     * @param EntityRepository $reviewRepository
     * @param ObjectManager $reviewManager
     * @param ReviewableRatingCalculatorInterface $averageRatingCalculator
     */
    public function __construct(
        EntityRepository $reviewRepository,
        ObjectManager $reviewManager,
        ReviewableRatingCalculatorInterface $averageRatingCalculator
    ) {
        $this->reviewRepository = $reviewRepository;
        $this->reviewManager = $reviewManager;
        $this->averageRatingCalculator = $averageRatingCalculator;
    }

    /**
     * {@inheritdoc}
     */
    public function removeReviewerReviews(ReviewerInterface $author)
    {
        $reviewSubjectsToRecalculate = [];

        foreach ($this->reviewRepository->findBy(['author' => $author]) as $review) {
            $reviewSubjectsToRecalculate = $this->removeReviewsAndExtractSubject($review, $reviewSubjectsToRecalculate);
        }
        $this->reviewManager->flush();

        foreach ($reviewSubjectsToRecalculate as $reviewSubject) {
            $reviewSubject->setAverageRating($this->averageRatingCalculator->calculate($reviewSubject));
        }
    }

    /**
     * @param ReviewInterface $review
     * @param ReviewableInterface[] $reviewSubjectsToRecalculate
     *
     * @return array
     */
    private function removeReviewsAndExtractSubject(ReviewInterface $review, array $reviewSubjectsToRecalculate)
    {
        $reviewSubject = $review->getReviewSubject();

        if (!in_array($reviewSubject, $reviewSubjectsToRecalculate)) {
            $reviewSubjectsToRecalculate[] = $reviewSubject;
        }

        $this->reviewManager->remove($review);

        return $reviewSubjectsToRecalculate;
    }
}
