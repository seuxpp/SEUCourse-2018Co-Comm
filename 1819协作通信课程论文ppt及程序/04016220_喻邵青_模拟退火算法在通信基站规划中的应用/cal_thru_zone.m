function cal_zone=cal_thru_zone(x1,y1,x2,y2,x0,y0)
    A=y2-y1;B=x1-x2;C=y1*(x2-x1)-(y2-y1)*x1;
    d2line=abs( (A*x0+B*y0+C) / sqrt(A^2 + B^2 ) );
    if(d2line<8)
    cal_zone=1;
    else
        cal_zone=0;
    end
end