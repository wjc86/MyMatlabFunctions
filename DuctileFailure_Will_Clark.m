function [ FS ] = DuctileFailure_Will_Clark(stress, yield_strength)
   %Variable definition
    Sy = yield_strength;
    sx = stress(1);
    sy = stress(2);
    txy = stress(3);
    sab = sort(eig([sx txy;txy sy]),'descend');
    [sp] = sort(eig([sx txy 0;txy sy 0;0 0 0]),'descend');
    
    hold on
    %plotting the axes
    title('Failure Surfaces')
    xlabel('Principle Stress a (ksi)')
    ylabel('Principle Stress b (ksi)')
    %plot x and y axes at y=0 and x=0
    plot([-1.5*Sy +1.5*Sy],[0 0],'k-');
    plot([0 0],[-1.5*Sy +1.5*Sy],'k-');
    %plotting the Tresca surface
    t = plot([Sy Sy 0 -Sy -Sy 0 Sy],[0 Sy Sy 0 -Sy -Sy 0],'r-');
    %Tresca SF
    tsf = (Sy/(sp(1)-sp(3)));
    %plotting the Von Mises surface: I did and explicit method soln for the
    %ellipse
    step = 0.0001;
    Sb = -sqrt(4*Sy^2/3):step:sqrt(4*Sy^2/3);
    Sa = [(Sb+sqrt(-3*Sb.^2+4*Sy^2))/2 , fliplr(Sb-sqrt(-3*Sb.^2+4*Sy^2))/2];
    Sb = horzcat(Sb,fliplr(Sb));
    u = plot(Sa,Sb,'g');
    %Von Mises SF
    vmsf = Sy/(sqrt(sab(1)^2-sab(1)*sab(2)+sab(2)^2));
    %plotting operating line
    if vmsf >=1
        v = plot([0 sab(1)*vmsf],[0 sab(2)*vmsf],'b');
        w = plot(sab(1),sab(2),'r*');
    else
        v = plot([0 sab(1)],[0 sab(2)],'b');
        w = plot(sab(1),sab(2),'r*');
    end
    FS = [vmsf tsf];
    legend([t u v w],"Tresca Surface","Von Mises Surface","Load Line","Operating Point");
end
