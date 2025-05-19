//
//  SnappingFlowLayout.swift
//  GasGo
//
//  Created by Emrah Zorlu on 19.05.2025.
//

import UIKit

final class SnappingFlowLayout: UICollectionViewFlowLayout {
  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    guard let collectionView = collectionView else {
      return super.targetContentOffset(
        forProposedContentOffset: proposedContentOffset,
        withScrollingVelocity: velocity
      )
    }
    let horizontalCenter = proposedContentOffset.x + collectionView.bounds.width / 2
    let targetRect = CGRect(
      x: proposedContentOffset.x, y: 0,
      width: collectionView.bounds.width,
      height: collectionView.bounds.height
    )
    
    let attributesArray: [UICollectionViewLayoutAttributes] = {
      if let attrs = super.layoutAttributesForElements(in: targetRect) {
        return attrs
      } else {
        return collectionView.indexPathsForVisibleItems.compactMap { layoutAttributesForItem(at: $0) }
      }
    }()
    
    if attributesArray.isEmpty {
      return super.targetContentOffset(
        forProposedContentOffset: proposedContentOffset,
        withScrollingVelocity: velocity
      )
    }
    var closestAttribute: UICollectionViewLayoutAttributes?
    for attributes in attributesArray {
      if closestAttribute == nil ||
          abs(attributes.center.x - horizontalCenter)
          < abs(closestAttribute!.center.x - horizontalCenter) {
        closestAttribute = attributes
      }
    }
    guard let nearest = closestAttribute else {
      return super.targetContentOffset(
        forProposedContentOffset: proposedContentOffset,
        withScrollingVelocity: velocity
      )
    }
    let newOffsetX = nearest.center.x - collectionView.bounds.width / 2
    return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
  }
}
