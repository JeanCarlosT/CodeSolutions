import UIKit

/*
 MARK: - Definition
 Linear search is also called as sequential search algorithm
 Linear search is a sequential searching algorithm where we start from one end and check every element of the list until the desired element is found.
*/

struct MessageResult{
 
    let data: [Int]
    let searchingValue: Int
    let position: Int?
    
    init(data: [Int],value searchingValue: Int,position: Int?) {
        self.data = data
        self.searchingValue = searchingValue
        self.position = position
    }
    
    func result(){
        print("The elements of the array are \(data)\nElement to be searched is \(searchingValue)\nElement is present at \(String(describing: position)) position of array")
    }
    
}

func linearSearch() -> MessageResult{
    var array = Array(1...10)
    array.shuffle()
    
    let numberToFind = Int.random(in: 1...20)
    
    for i in 0..<array.count{
        if array[i] == numberToFind{
            return MessageResult(
                data: array,
                value: numberToFind,
                position: i
            )
        }
    }
    
    return MessageResult(
        data: array,
        value: numberToFind,
        position: nil
    )
}

linearSearch().result()
