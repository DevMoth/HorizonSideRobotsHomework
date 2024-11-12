function sumRec(vect, summ = 0, ind = 1)
    if lastindex(vect) <= ind
        return summ+vect[ind]
    end
    return sumRec(vect, summ+vect[ind], ind+1)
end
sum([1,2,3,4])