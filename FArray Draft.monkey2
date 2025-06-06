Class FArray<T> Implements IContainer<T>
    
	' iDkP from GaragePixel
	' 2025-03-12
	'
	' The FArray class implements a flexible array structure 
	' that supports multi-Sub arrays with dynamic sizing,
	' allowing flexible manipulation and iteration 
	' over the multi-Sub model.
	'
	' Note:
	'	It's the first time I implement multi-iterators in the
	'	same class and this basic class take me ~20 hours to write.
	'	I learn a lot during this project.
	'
	'	It's actually only a draft. I will implement some manipulation
	'	helpers about the Subs. The finished class will be
	'	in stdlib you will find in my repositiories.
	'
	' COMPLETED:
	'
	'	2025-03-13: 
	'		- In SubIterator:
	'			- Added First, Last, Pred, Succ, FirstValue and LastValue in the SubIterator. 
	'			- Completed the print set and updated the test unit.
	'			- List grammar.
	'			- FiFo grammar.
	'
	'	2025-03-12:
	'		First public draft of the implementation
	'		called FArray, which is a class
	'
	'	2025-03-10:
	'		First draft attempted to fill the missing features
	'		in a struct called MArray, actually used in a
	'		implementation of matrices m*n (missing again
	'		as a basic datatype in Mx2). MArray dummie code at:
	'		https://discord.com/channels/796336780302876683/870267572812128298/1348692174946041916
	'		It's not worth breaking three legs of a duck.
	'
	'	2025-03-10: 
	'		Discovering about the missing implementations
	'		in the built-in of multisubs arrays
	'		since New Float[,]((1,2,3),(4,5,6)) is invalid.
	'		https://discord.com/channels/796336780302876683/870267572812128298/1348675928867344516
	'
	' TODO:
	'		- Make Sub adressing zero-based
	'
	'		- Add helpers for manipulate items within FArray.
	'
	'		- Add constructor for setting a FArray from a list of lists
	'		in the form: New FArray(New List(New List(1,2,3),New List(4,5,6)))
	'
	'		- Add constructor for setting a FArray from a string
	'		in the form: New FArray<Variant>(\"(1,2,3),(4,5,6)\")
	'		(need to write a tokenizer with reflexion capabilities
	'		and using Variant)
	'
	'		- Manage to write the equivalent with the databuffer 
	'		manipulating multisubs-arranged built-in data types 
	'		in a one-dimensional model. 
	'
	'		- Get some stars in my repository if you find this useful for you
	'		or just interesting.

	' Constructor
	Method New(sizes:UInt[], data:T[])
		_sizes = sizes
		_data = data
		_length = _data.Length
	End
	
	Property Length:UInt()	  ' Property to get the total length of the array   
		Return _length
	End
			
	Property Sizes:UInt[]()	 ' Property to get the sizes of the Subs
		Return _sizes
	End

	Method Subs:UInt(dim:UInt = Null) ' Pseudo-property
		' Returns the number of Subs,
		' or the length of a particular Sub.		
		Return dim=Null ? _sizes.Length Else _sizes[dim]
	End
	
	Operator To:String()
	
		Local result:String="FArray=("
		Local _dataLenSub1:=_data.Length-1
		For Local n:=0 Until _dataLenSub1
			result+=_data[n]+","
		End	 
		Return result+_data[_data.Length-1]+")"
	End
	
	Method ToString:String()
	
		Local result:String = ""
		Local index:Int = 0
		
		Local sizesLen:=_sizes.Length
		Local sizesdim:UInt
		For Local dim:Int = 0 Until sizesLen
			result += "Sub " + (dim + 1) + " contains: "
			sizesdim=_sizes[dim]
			For Local i:Int = 0 Until sizesdim
				result += _data[index]
				If i < _sizes[dim] - 1
					result += ", "
				End
				index += 1
			End
			result += "~n"
		End		
		Return result
	End
				
	Method All:FArrayLinearIterator<T>()
		' Returns the linear iterator	
		Return New FArrayLinearIterator<T>(Self)
	End

	Method Contains:Bool(value:T)
		' Function to check if the FArray contains a value.
		Local result:Bool=False
		For Local i:Int = 0 Until _data.Length
			If _data[i] = value 
				result=True
				Exit 
			End
		Next
		Return result
	End
	Method GetValue:T(index:UInt)
		' Function to get the value at specified index in the unidimensional array.
		If index > _data.Length-1 Or index<0
			RuntimeError("Index out of range")
		End
		Return _data[index]
	End
		
	Method SetValue(index:UInt, value:T)
		' Function to set the value at specified index in the unidimensional array.
		If index > _data.Length-1 Or index<0
			RuntimeError("Index out of range")
		End
		_data[index] = value
	End
	
	Method Sub:SubIterator<T>(dim:UInt)
		' Returns the Sub iterator	
		Return New SubIterator<T>(Self, dim)
	End

	Method Append(dim:UInt, items:T[], beforeFirstItem:Bool=False)
	
		' Append an array at the end of a Sub, or before the 1st item.
		
		' Appends a new set
		If dim < 1 Or dim > _sizes.Length
			RuntimeError("Sub out of range")
		End

		Local newSize:UInt = _sizes[dim-1] + items.Length
		Local newData:T[] = New T[_length + items.Length]
		
		Local index:Int = 0
		Local newIndex:Int = 0

		' Copy elements up to the appended set
		For Local i:Int = 0 Until dim - 1
			For Local j:Int = 0 Until _sizes[i]
				newData[newIndex] = _data[index]
				index += 1
				newIndex += 1
			End
		End

		If beforeFirstItem

			' Append new set elements
			For Local i:Int = 0 Until items.Length
				newData[newIndex] = items[i]
				newIndex += 1
			End		
		End 
		
		' Copy remaining elements
		For Local i:Int = 0 Until _sizes[dim - 1]
			newData[newIndex] = _data[index]
			index += 1
			newIndex += 1
		End

		If beforeFirstItem=False

			' Append new set elements
			For Local i:Int = 0 Until items.Length
				newData[newIndex] = items[i]
				newIndex += 1
			End		
		End 
		
		' Copy elements after the appended set
		For Local i:Int = dim Until _sizes.Length
			For Local j:Int = 0 Until _sizes[i]
				newData[newIndex] = _data[index]
				index += 1
				newIndex += 1
			End
		End
		
		_length += items.Length
		_data = newData
		_sizes[dim-1] = newSize
	End

	Method RemoveDim(dim:UInt)
		' Delete a Sub
		If dim < 1 Or dim > _sizes.Length
			RuntimeError("Sub out of range")
		End
		Local start:Int = 0
		For Local i:Int = 0 Until dim - 1
			start += _sizes[i]
		End
		Local atEnd:Int = start + _sizes[dim - 1]
		
		Local newData:T[] = New T[_length - (atEnd - start)]
		For Local i:Int = 0 Until start
			newData[i] = _data[i]
		End
		For Local i:Int = atEnd Until _length
			newData[i - (atEnd - start)] = _data[i]
		End
	
		' Create new sizes array without the deleted Sub
		Local newSizes:UInt[] = New UInt[_sizes.Length - 1]
		For Local i:Int = 0 Until dim - 1
			newSizes[i] = _sizes[i]
		End
		For Local i:Int = dim Until _sizes.Length
			newSizes[i - 1] = _sizes[i]
		End
	
		_data = newData
		_sizes = newSizes
		_length -= (atEnd - start)
	End
	
	Class FArrayLinearIterator<T> Implements IIterator<T>
		
		' Linear Iterator class
		
		Private
		
		Field _flexArray:FArray<T>
		Field _currentIndex:Int
		
		Public
		
		Method New(flexArray:FArray<T>)
			_flexArray = flexArray
			_currentIndex = 0
		End
		
		Property AtEnd:Bool()
			Return _currentIndex >= _flexArray._length
		End
		
		Property Current:T()
			If AtEnd
				RuntimeError("No more elements")
			End
			Return _flexArray._data[_currentIndex]
		End
		
		Method Bump()
			_currentIndex += 1
		End

		Method Remove()
			
			If AtEnd
				RuntimeError("Cannot remove element at end")
			End
			
			' Shift elements left and reduce length
			For Local i:Int = _currentIndex Until _flexArray._length - 1
				_flexArray._data[i] = _flexArray._data[i + 1]
			End
			_flexArray._length -= 1
			_flexArray._data = _flexArray._data.Slice(0, _flexArray._length)
			
			' Update sizes
			If _flexArray._sizes.Length > 0
				_flexArray._sizes[0] -= 1
			End
		End

		Method Insert(value:T)
			
			' Resize and shift elements right
			_flexArray._data = _flexArray._data.Slice(0, _flexArray._length + 1)
			For Local i:Int = _flexArray._length - 1 Until _currentIndex - 1 Step -1
				_flexArray._data[i + 1] = _flexArray._data[i]
			End
			_flexArray._data[_currentIndex] = value
			_flexArray._length += 1
			
			' Update sizes
			If _flexArray._sizes.Length > 0
				_flexArray._sizes[0] += 1
			End
		End
	End
	Class SubIterator<T> Implements IIterator<T>
		
		' Sub Iterator class to iterate over items in a specific Sub
		
		Private 
		
		Field _flexArray:FArray<T>
		Field _dim:UInt
		Field _currentIndex:UInt
		Field _lowerLim:UInt
		Field _upperLim:UInt
		
		Public
		
		Method New(flexArray:FArray<T>, dim:UInt)
			_flexArray = flexArray
			_dim = dim
			CalculateLimits()
			_currentIndex = _lowerLim
		End		

		Operator To:String()
		
			'Return a string containing the list of the Sub's items
		
			Local result:String="Sub("+_dim+")=("
			For Local n:=_lowerLim - 1 Until _upperLim-1
				result+=_flexArray._data[n+1]+","
			End
			Return result+_flexArray._data[_upperLim]+")"
		End
		
		Method Item:String(item:UInt) 'Pseudo-property
			
			'Returns a string containing the string casted item
			'(the item's datatype must be printable)

			Within(item,_lowerLim,_upperLim)
			Return _flexArray._data[_lowerLim+item]
		End 
		
		Method CalculateLimits()
			
			' Calculate the lower and upper limits based on the Sub
			
			_lowerLim = 0
			_upperLim = 0
			Local i:UInt
			For i = 0 Until _dim
				_upperLim += _flexArray.Sizes[i]
			End
			_lowerLim = _upperLim - _flexArray.Sizes[i-1]
			_upperLim -= 1
		End

		Property AtEnd:Bool()
			Return _currentIndex > _upperLim
		End
		
		Property Current:T()
			If AtEnd
				RuntimeError("No more elements")
			End
			Return _flexArray._data[_currentIndex]
		End

		Property FirstValue:T()
			Return _flexArray._data[_lowerLim]
		End

		Property LastValue:T()
			Return _flexArray._data[_lowerLim + (_upperLim - _lowerLim)]
		End

		Method First()
			'Move the _currentIndex to the first item
			_currentIndex = _lowerLim
		End

		Method Last()
			'Move the _currentIndex to the last item
			_currentIndex = _lowerLim + (_upperLim - _lowerLim)
		End

		Method Succ()
			'Next iterator's item from _currentIndex
			_currentIndex += 1
			If _currentIndex > _upperLim
					RuntimeError("Item out of range")
			End
		End

		Method Pred()
			'Next predecessor's item from _currentIndex
			_currentIndex -= 1
			If _currentIndex < 0
					RuntimeError("Item out of range")
			End
		End
		
		Method Bump()
			_currentIndex += 1
		End

		Method Remove()
			
			If AtEnd
				RuntimeError("Cannot remove element at end")
			End
			
			' Shift elements left and reduce length
			For Local i:Int = _currentIndex Until _flexArray._length - 1
				_flexArray._data[i] = _flexArray._data[i + 1]
			End
			_flexArray._length -= 1
			_flexArray._data = _flexArray._data.Slice(0, _flexArray._length)
			
			' Adjust limits and sizes
			_upperLim -= 1
			If _dim <= _flexArray._sizes.Length
				_flexArray._sizes[_dim - 1] -= 1
				If _flexArray._sizes[_dim - 1] = 0				
					' Remove the Sub from _sizes
					Local newSizes:UInt[] = New UInt[_flexArray._sizes.Length - 1]					
					For Local i:Int = 0 Until _dim - 1
						newSizes[i] = _flexArray._sizes[i]
					End					
					For Local i:Int = _dim Until _flexArray._sizes.Length
						newSizes[i - 1] = _flexArray._sizes[i]
					End
					_flexArray._sizes = newSizes
				End
			End
		End
		
		Method RemoveLast()
			'Semi-Sugar
			Last()
			Remove()
			Last()
		End

		Method RemoveFirst()
			'Semi-Sugar
			First()
			Remove()
			First()
		End

		Method Pop()
			'Sugar
			RemoveFirst()
		End

		Method Push(value:T)
			'Sugar
			First()
			Insert(value)
		End

		Method Insert(value:T)
			
			' Resize and shift elements right
			_flexArray._data = _flexArray._data.Slice(0, _flexArray._length + 1)
			For Local i:Int = _flexArray._length - 1 Until _currentIndex - 1 Step -1
				_flexArray._data[i + 1] = _flexArray._data[i]
			End
			_flexArray._data[_currentIndex] = value
			_flexArray._length += 1
			
			' Adjust limits and sizes
			_upperLim += 1
			If _dim <= _flexArray._sizes.Length
				_flexArray._sizes[_dim - 1] += 1
			Else
				' Create a new array with the inserted value
				Local newSizes:UInt[] = New UInt[_flexArray._sizes.Length + 1]
				For Local i:Int = 0 Until _dim - 1
					newSizes[i] = _flexArray._sizes[i]
				End
				newSizes[_dim - 1] = 1
				For Local i:Int = _dim - 1 Until _flexArray._sizes.Length
					newSizes[i + 1] = _flexArray._sizes[i]
				End
				_flexArray._sizes = newSizes
			End
		End
	    
	    Private 'tools
	    
	    Method Within(item:UInt,a:UInt,b:UInt)
        	If item < b - a - 1 - _lowerLim Or item > b - a
   	        	RuntimeError("Sub out of range")
	        End
		End   
	End
	
    Private

    Field _sizes:UInt[]
    Field _data:T[]
    Field _length:UInt
End
