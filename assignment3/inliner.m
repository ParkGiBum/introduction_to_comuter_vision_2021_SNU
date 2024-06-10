function [in , d]  = inliner(points1,points2,H,t)
    d = distance(points1,points2,H);
    if d<t
        in = true;
    else
        in = false;
    end
    
end