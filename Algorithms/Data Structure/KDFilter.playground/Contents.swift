import UIKit
import Foundation

typealias PointsType = [[Double]]

let K = 2 /// This describe the amount of dimensions that we are going to use, for tthis case ( x , y )

/// The nearest point is [803.07129, 323.03201]
let testablePoints1:PointsType = [
    [63.63961,144.23502],
    [222.23357,385.66147],
    [545.48236,146.25533],
    [645.48749,502.83917],
    [1043.4875,168.47868],
    [1494.0156,590.72247],
    [1096.0155,661.43311],
    [803.07129,323.03201],
    [358.60416,654.36206],
    [510.12704,321.01172],
    [852.56873,677.59558]
]

let pivotPoint1: [Double] = [953.58398,382.63101]

/// The nearest point is [140,110]
let testablePoints2: PointsType = [
    [40,70],
    [70,130],
    [90,40],
    [110,100],
    [140,110],
    [150,30],
    [160,100]
]

let pivotPoint2: [Double] = [140,90]

/// The nearest point [93.825714,78.357788]
let testablePoints3: PointsType = [
    [63.218227, 61.044964],
    [93.825714,78.357788],
    [87.397141,99.220558]
]

let pivotPoint3: [Double] = [80.749451,71.580406]


//MARK: - utilities

/// Calculates the distance between two points  in x and y
/// - Parameters:
///   - point1: point one, array of doubles
///   - point2: point two, array of doubles
/// - Returns: distance between those points in X and Y
func distance_squared(_ point1:[Double],_ point2:[Double]) -> Double {
    let x1 = point1[0]
    let y1 = point1[1]
    
    let x2 = point2[0]
    let y2 = point2[1]
    
    let dx = x1 - x2
    let dy = y1 - y2
    
    return dx * dx + dy * dy
}

/// This function is going to return the nearest distance between two points related to the pivot, so the nearest point is going to be the result
/// - Parameters:
///   - pivot: point of interest
///   - point1: this is one of the two points to compare according the pivot
///   - point2: this is the second point to compare according to the pivot
///   - return: return the nearest compared point according to the pivot
func closer_distance(pivot:[Double],point1:[Double],point2: [Double]) -> [Double]{
    if point1.isEmpty {
        return point2
    }
    
    if point2.isEmpty{
        return point1
    }
    
    /// Calcula la distancia de los puntos de acuerdo al pivot
    let d1 = distance_squared(pivot, point1)
    let d2 = distance_squared(pivot, point2)
    
    if d1 < d2{
        return point1
    }else{
        return point2
    }
}

//MARK: - We have to build the K-D tree
/// Create the K - D tree, K = dimensions, D = iteration depth
/// Left = smaller data
/// Right = bigger data
/// - Parameters:
///   - points: points to organize in a tree,
///   - depth: Level of profunudity of iteration
func build_kdTree(points: PointsType,depth: Int = 0) -> [String : Any]{
    
    let arrayLength = points.count
    
    if arrayLength <= 0{ /// If there's not points so return an empty tree
        return [String : Any]()
    }
    
    let axis = depth % K /// Splitting axis,  (0 = x , 1 = y)
    
    // TODO: validar que el eje siempre sea menor al tamaño del arreglo
    
    /// We Sorts the iterable in ascending order taking account the axis
    let sorted_points = points.sorted { $0[axis] < $1[axis] }
    
    let midlePoint = arrayLength/2
    
    let leftPoints = Array(sorted_points.prefix(midlePoint))
    
    let rightPoints = Array(sorted_points[(midlePoint + 1)..<arrayLength])
    
    let result: [String : Any] = [
        "point": sorted_points[midlePoint],
        "left": build_kdTree(points: leftPoints, depth: depth + 1),
        "right": build_kdTree(points: rightPoints, depth: depth + 1)
    ]
    
    return result
}

//MARK: - Now ee have to build a function to filter into the tree
/// Search for the nearest point in the tree related to the point that we want to find
///  - THIS FUNCTION HAS A PROBLEM. ( it doesn't iterate the siblings branches, to check if we miss the sibligs sub-tree with a better answer   )
/// - Parameters:
///   - root: At the beginning is the tree itself, however while iterating it becamos to the branches of the tree
///   - point: point of interest
///   - depth: Level of profunudity of iteration
///   - best: the best option find in each iteration
/// - Returns: the best option find (the nearest )
///
func kdTree_naive_closest_point(root:[String : Any],point:[Double],depth: Int = 0, best:[Double] = .init()) -> [Double]{
    
    if root.isEmpty {///We check if there's not more leaf of the tree and return the best option so far
        return best
    }

    let axis = depth % K /// we get the axis
    
    /// We have to respond two questions
    /// 1. Did we find the best point so far?
    /// 2. Wha is the next branch of the recursion?
    
    var next_best:[Double] = .init() /// es para obtener el mejor resultado
    var next_branch: [String : Any] = .init() ///Valida si sigue hacia la izquierda o hacia la derecha
    
    guard
        point.count == 2,
        let rootPoint = root["point"] as? [Double],
        rootPoint.count == 2
    else { return .init() }
    
    
    if best.isEmpty || distance_squared(point, best) > distance_squared(point, rootPoint){
        next_best = rootPoint
    }else{
        next_best = best
    }
    
    
    /// Check the next axis
    guard
        let leftSide = root["left"] as? [String : Any],
        let rightSide = root["right"] as? [String : Any]
    else { return .init() }
    
    if point[axis] < rootPoint[axis]{
        next_branch = leftSide
    }else{
        next_branch = rightSide
    }
    
    return kdTree_naive_closest_point(root: next_branch, point: point,depth: depth + 1,best: next_best)
}

///  Search for the nearest point in the tree related to the point that we want to find
/// - Parameters:
///   - root: At the beginning is the tree itself, however while iterating it becamos to the branches of the tree
///   - point: point of interest
///   - depth: Level of profunudity of iteration
/// - Returns: the best option find (the nearest )
func kdTree_closest_point(root:[String : Any],point:[Double],depth: Int = 0) -> [Double] {
    
    if root.isEmpty{
        return .init()
    }
    
    let axis = depth % K /// we get the axis
    
    /// We have to respond two questions, because sometime we have to go the opposite childa just to chekc if there is a better answer
    /// 1. Wha is the opposite branch of the recursion?
    /// 2. Wha is the next branch of the recursion?
    
    var next_branch: [String : Any] = .init() ///Valida si sigue hacia la izquierda o hacia la derecha
    var opposite_branch: [String : Any] = .init() ///Valida si sigue hacia la izquierda o hacia la derecha
    
    guard
        point.count == 2,
        let rootPoint = root["point"] as? [Double],
        rootPoint.count == 2,
        let leftSide = root["left"] as? [String : Any],
        let rightSide = root["right"] as? [String : Any]
    else { return .init() }
    
    if point[axis] < rootPoint[axis]{
        next_branch = leftSide
        opposite_branch = rightSide
    }else{
        next_branch = rightSide
        opposite_branch = leftSide
    }
    
    let somRecursiveResultNextBranch = kdTree_closest_point(root: next_branch, point: point,depth: depth + 1)
    
    ///Now we have to check is the current splitting point is better than the
    var best = closer_distance(
        pivot: point,
        point1: somRecursiveResultNextBranch,
        point2: rootPoint
    )
    
    if distance_squared(point, best) > abs(point[axis] - rootPoint[axis]){
       
        /// We calculate the result but in the opposite branch
        let somRecursiveResultOppositeBranch = kdTree_closest_point(root: opposite_branch, point: point,depth: depth + 1)
        
        best = closer_distance(
            pivot: point,
            point1: somRecursiveResultOppositeBranch,
            point2: best
        )
    }
    
    return best
}


//MARK: -  OUTPUTS
let kdTree = build_kdTree(points: testablePoints2)

//let best = kdTree_naive_closest_point(root: kdTree, point: pivotPoint3)

let best2 = kdTree_closest_point(root: kdTree, point: pivotPoint2)

//print(best)

print(best2)

