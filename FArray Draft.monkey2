Class FArray<T> Implements IContainer<T>
    
    ' iDkP from GaragePixel
    ' 2025-03-12
    '
    ' The FArray class implements a flexible array structure 
    ' that supports multi-dimensional arrays with dynamic sizing,
    ' allowing flexible manipulation and iteration 
    ' over the multi-dimensional.
    '
    ' Note:
    '	It's the first time I implement multi-iterators in the
    '	same class and this basic class take me ~20 hours to write.
    '	It's not really fast but I learn a lot during this project.
    '
    '	It's actually only a draft. I will implement some manipulation
    '	helpers about the dimensions. The finished class will be
    '	in stdlib you will find in my repositiories.
    '
    '   You are invited to test it in its extreme values and make a stress test too.
    '   Please push request if you think you can improve it or fix it.
    '   This class will be implemented in stdlib so please avoid to make a library with it, thanks^^

    ' Constructor
    Method New(sizes:UInt[], data:T[])
        _sizes = sizes
        _data = data
        _length = _data.Length
    End
    
    Property Length:UInt()      ' Property to get the total length of the array   
        Return _length
    End
        
    Property Sizes:UInt[]()     ' Property to get the sizes of the dimensions
        Return _sizes
    End

    Method Dimensions:UInt(dim:UInt=Null) ' Pseudo-property
        ' Returns the number of dimensions,
        ' or the length of a particular dimension.        
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
            result += "Dimension " + (dim + 1) + " contains: "
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
    
    Method Dimension:DimensionIterator<T>(dim:UInt)
        ' Returns the dimension iterator    
        Return New DimensionIterator<T>(Self, dim)
    End

    Method Append(dim:UInt, newDim:T[], beforeFirstItem:Bool=False)
	    
	    'Append an array at the end of a dimension, or before the 1st item.
	    
        ' Appends a new dimension
        If dim < 1 Or dim > _sizes.Length
            RuntimeError("Dimension out of range")
        End

        Local newSize:UInt = _sizes[dim-1] + newDim.Length
        Local newData:T[] = New T[_length + newDim.Length]
        
        Local index:Int = 0
        Local newIndex:Int = 0

        ' Copy elements up to the appended dimension
        For Local i:Int = 0 Until dim - 1
            For Local j:Int = 0 Until _sizes[i]
                newData[newIndex] = _data[index]
                index += 1
                newIndex += 1
            End
        End

		If beforeFirstItem

	        ' Append new dimension elements
	        For Local i:Int = 0 Until newDim.Length
	            newData[newIndex] = newDim[i]
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

	        ' Append new dimension elements
	        For Local i:Int = 0 Until newDim.Length
	            newData[newIndex] = newDim[i]
	            newIndex += 1
	        End
        
        End 
        
        ' Copy elements after the appended dimension
        For Local i:Int = dim Until _sizes.Length
            For Local j:Int = 0 Until _sizes[i]
                newData[newIndex] = _data[index]
                index += 1
                newIndex += 1
            End
        End
        
        _length += newDim.Length
        _data = newData
        _sizes[dim-1] = newSize
    End

    Method DeleteDim(dim:UInt)
        ' Delete a dimension
        If dim < 1 Or dim > _sizes.Length
            RuntimeError("Dimension out of range")
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
    
        ' Create new sizes array without the deleted dimension
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
    
    Private

    Field _sizes:UInt[]
    Field _data:T[]
    Field _length:UInt
    
    Class FArrayLinearIterator<T> Implements IIterator<T>
        
        ' Linear Iterator class
        
        Field _flexArray:FArray<T>
        Field _currentIndex:Int
        
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

        Method Erase()
	        
            If AtEnd
                RuntimeError("Cannot erase element at end")
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
    
    Class DimensionIterator<T> Implements IIterator<T>
        
        ' Dimension Iterator class to iterate over items in a specific dimension
        
        Field _flexArray:FArray<T>
        Field _dim:UInt
        Field _currentIndex:UInt
        Field _lowerLim:UInt
        Field _upperLim:UInt
        
        Method New(flexArray:FArray<T>, dim:UInt)
            _flexArray = flexArray
            _dim = dim
            CalculateLimits()
            _currentIndex = _lowerLim
        End        
        
        Method CalculateLimits()
            
            ' Calculate the lower and upper limits based on the dimension
            
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
        
        Method Bump()
            _currentIndex += 1
        End

        Method Erase()
	        
            If AtEnd
                RuntimeError("Cannot erase element at end")
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
                    ' Remove the dimension from _sizes
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
    End
End

Function FArrayTest()
    
    ' Test function for the DimensionIterator

    ' Initialize the array sizes and data
    Local sizes2 := New UInt[](3, 2, 4, 1)
    Local data2 := New Float[](1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0)
    Local sArray2:FArray<Float> = New FArray<Float>(sizes2, data2)

    ' Test Dimension Iterator for dimension 3
    Print "Testing Dimension Iterator for Dimension 3:"
    For Local item:Float = Eachin sArray2.Dimension(3)
        Print item
    Next
    Print sArray2
    Print sArray2.ToString()

    ' Test Linear Iterator
    Print "Testing Linear Iterator:"
    For Local item:Float = Eachin sArray2
        Print item
    Next

    ' Test Erase in Linear Iterator
    Print "Testing Erase in Linear Iterator:"
    Local linearIterator := sArray2.All()
    linearIterator.Bump() ' Move to second element
    linearIterator.Erase()
    Print sArray2
    Print sArray2.ToString()

    ' Test Insert in Linear Iterator
    Print "Testing Insert in Linear Iterator:"
    linearIterator = sArray2.All()
    linearIterator.Bump() ' Move to second element
    linearIterator.Insert(99.9)
    Print sArray2
    Print sArray2.ToString()

    ' Test Erase in Dimension Iterator
    Print "Testing Erase in Dimension Iterator for Dimension 3:"
    Local dimIterator := sArray2.Dimension(3)
    dimIterator.Bump() ' Move to second element
    dimIterator.Erase()
    For Local item:Float = Eachin sArray2.Dimension(3)
        Print item
    Next
    Print sArray2
    Print sArray2.ToString()
    
    ' Test Insert in Dimension Iterator
    Print "Testing Insert in Dimension Iterator for Dimension 3:"
    dimIterator = sArray2.Dimension(3)
    dimIterator.Bump() ' Move to second element
    dimIterator.Insert(88.8)
    For Local item:Float = Eachin sArray2.Dimension(3)
        Print item
    Next
    Print sArray2
    Print sArray2.ToString()

    ' Test Append new dimension
    Local newDim := New Float[](20, 30, 40)
    sArray2.Append(2, newDim)
    Print "Testing Append new dimension:"
    Print sArray2
    Print sArray2.ToString()

    ' Test Delete dimension
    sArray2.DeleteDim(3)
    Print "Testing Delete dimension:"
    Print sArray2
    Print sArray2.ToString()
End
