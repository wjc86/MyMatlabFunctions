function [FS] = BrittleFailure_Will_Clark(stress, uts)
    % Stress State is still just sigmaX,Y,TauXY 
    sx = stress(1);
    sy = stress(2);
    txy = stress(3);
    % uts expects [ultimateStrengthTension,ultimateStrengthCompression]
    Tuts = uts(1);
    Cuts = uts(2);
    % Get Sigma A,B
    sab = sort(eig([sx txy;txy sy]),'descend');
    [sp] = sort(eig([sx txy 0;txy sy 0;0 0 0]),'descend');
    sa = sab(1);
    sb = sab(2);
    rba = abs(sb/sa);
    %Max normal safety factor
    sfmn = min([abs(Tuts/sa) abs(Cuts/sb)]);
    % BCM safety factor
    if sa>=sb && sb >=0
        sfbcm = Tuts/sa;
        sfmm = sfbcm;
    elseif sa >=0 && 0>=sb
        sfbcm = 1/((sa/Tuts)-(sb/Cuts));
        if rba <= 1
            sfmm = Tuts/sa;
        else
            sfmm = 1/((sa*((Cuts-Tuts)/(Cuts*Tuts)))-(sb/Cuts));
        end
    else
        sfbcm = -Cuts/sb;
        sfmm = sfbcm;
    end
    % return Safety Factors ( MN, BCM, MM,
    FS = [sfmn sfbcm sfmm];
    % Plotting
    hold on
    %plot x and y axes at y=0 and x=0
    plot([-1.5*Cuts 1.5*Tuts],[0 0],'k-');
    plot([0 0],[-1.5*Cuts 1.5*Tuts],'k-');
    %Max normal Square
    q = plot([-Cuts,-Cuts,Tuts,Tuts,-Cuts],[Tuts,-Cuts,-Cuts,Tuts,Tuts],'--g');
    %BCM
    w = plot([-Cuts,-Cuts,0,Tuts,Tuts,0,-Cuts],[0,-Cuts,-Cuts,0,Tuts,Tuts,0],'b-');
    %MM
    r = plot([-Cuts,-Cuts,0,Tuts,Tuts,-Tuts,-Cuts],[0,-Cuts,-Cuts,-Tuts,Tuts,Tuts,0],'r-');
    % Operating Point
    y = plot(sa,sb,'m*');
    if sfmn <1
        u = plot([0 sa],[0 sb],'y');
    else
        u = plot([0 sa*sfmm],[0 sb*sfmm],'y');
    end
    title('Failure Surfaces')
    xlabel('Principle Stress a (ksi)')
    ylabel('Principle Stress b (ksi)')
    legend([q w r y u],"Max Normal","Brittle Coulomb-Mohr","Modified Mohr","Operating Point","Load Line");
    