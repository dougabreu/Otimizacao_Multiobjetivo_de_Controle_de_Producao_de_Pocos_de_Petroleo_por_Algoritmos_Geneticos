function ValveGrafBehavior = Model_Equations()

z = 0:.005:1;

A = 10;
QuickOpening = (1 - exp(-A*z));

SquareRoot = sqrt(z);

Linear = z;

B = 0.63;
EqualPercentage =  - log(-.82*z + 1)/1.715;

SquareRoot2 = sqrt(z);

ModifiedParabolic = z.^3;


ValveGrafBehavior = plot(z,QuickOpening,z,SquareRoot,z,Linear,z,EqualPercentage,z,ModifiedParabolic);
ylim([0 1.1]);
xlabel('Porcentagem de abertura da válvula [%]');
ylabel('Porcentagem da vazão máxima [%]');
legend('Quick Opening','Square Root', 'Linear', 'Equal Percentage','Modified Parabolic');

end
