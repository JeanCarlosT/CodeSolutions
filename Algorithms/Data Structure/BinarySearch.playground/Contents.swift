import UIKit

/*
 MARK: Binary Search
 Binary Search is a searching algorithm for finding an element's position in a sorted array.

 In this approach, the element is always searched in the middle of a portion of an array.

 Binary search can be implemented only on a sorted list of items. If the elements are not sorted already, we need to sort them first.
 
 */

/// 1. The array in which searching is to be performed is:
///  We have to sort the array in case is required
let array = [3,4,5,6,7,8,9]

/// 1.1 número a buscar
let searchValue = 4

/// 2. Set two pointers low and high at the lowest and the highest positions respectively.
let low = array.min()!
let high =  array.max()!

func binarySearch(array: [Int], searchValue: Int, low: Int,high: Int)->Int{
   
    if low > high{
        return -1
    }else{
        let midValue = (low + high/2)
        if searchValue == array[midValue]{ /// si el valor a buscar es el punto medio entonces se retorna
            return midValue
        }else if searchValue > array[midValue]{ /// si el valor a buscar es mayor al punto medio, busca hacia la derecha
            return binarySearch(
                array: array,
                searchValue: searchValue,
                low: midValue + 1,
                high: high
            )
        }else{///si el valor a buscar es menor al punto medio entonces resta uno en la altura media
            return binarySearch(
                array: array,
                searchValue: searchValue,
                low: low,
                high: midValue - 1
            )
        }
    }
}

let result = binarySearch(
    array: array,
    searchValue: searchValue,
    low: low,
    high: high
)

print(result)

