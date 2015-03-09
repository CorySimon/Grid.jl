# 1D interpolation on a regularly spaced grid

using DataFrames

type Interp1d
    # attributes are a sorted x and y array
    x_sorted::Union(DataArray{Float64}, Array{Float64})
    y::Union(DataArray{Float64}, Array{Float64})

    # functions
    interpolate::Function

    # constructor
    function Interp1d(x::Union(Array{Float64}, DataArray{Float64}), y::Union(Array{Float64}, DataArray{Float64}))
        interp1d = new()
        ids_sorted = sortperm(x)
        interp1d.x_sorted = x[ids_sorted]
        interp1d.y = y[ids_sorted]

        interp1d.interpolate = function(x::Float64)
            """
            Interpolate data at point x
            """
            if ((x < interp1d.x_sorted[1]) | (x > interp1d.x_sorted[end]))
                error(@sprintf("x = %f outside range of data\n", x))
            end

            # find data points bracketing x
            id_right = searchsortedfirst(interp1d.x_sorted, x)
            
            # define linear interpolation function
            slope = (interp1d.y[id_right] - interp1d.y[id_right-1]) / (interp1d.x_sorted[id_right] - interp1d.x_sorted[id_right-1])
            f(z) = interp1d.y[id_right] + slope * (z - interp1d.x_sorted[id_right])

            return f(x)
        end
        
 #         interp1d.interpolate = function(x::Union(DataArray{Float64}, Array{Float64}))
 #             """
 #             Interpolate an entire array
 #             """
 #             y_interp = zeros(length(x))
 #             for i = 1:length(x)
 #                 y_interp[i] = interp1d.interpolate(x[i])
 #             end
 #             return y_interp
 #         end
        return interp1d
    end
end
