// Sorting function (bubble sort)
void sort(int *array, int size)
{
    int swapped;
    for (int i = 0; i < size - 1; ++i)
    {
        swapped = 0;
        for (int j = 0; j < size - i - 1; ++j)
        {
            if (array[j] > array[j + 1])
            {
                // Swap elements without using a separate swap function
                array[j] = array[j] + array[j + 1];
                array[j + 1] = array[j] - array[j + 1];
                array[j] = array[j] - array[j + 1];
                swapped = 1;
            }
        }
        // If no two elements were swapped in the inner loop, the array is already sorted
        if (!swapped)
        {
            break;
        }
    }
}