function dublicate_flags(park_flags)
[~, w] = unique( park_flags(park_flags>0), 'stable' );
duplicate_indices = setdiff( 1:numel(park_flags(park_flags>0)), w );
if(duplicate_indices)
    bug = 1;
end