function main_CtrlSurf()
disp('   ')
disp('"""""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('"  Control Surface Deflection  Analysis                 "')
disp('"""""""""""""""""""""""""""""""""""""""""""""""""""""""""')
disp('    [1]. Aerodynamic with Control Surface Deflection ')
disp(' ')
disp('    [2]. Fixed Control Derivetive Analysis ')
disp('    [3]. Deflection Related Control Derivative Analysis (Under Development)')
disp(' ')
disp('    [4]. Hinge Moment Analysis ')
disp(' ')
disp('    [0]. Return')
disp(' ')


answ=input('	Please enter choice from above: ');
      
if isempty(answ)
    answ=0;
end

disp(' ')

switch answ
    case 1
        [~]=solver_ADdflt();

    case 2     %Fixed Control Derivetive Analysis
        [~,~]=CDRV_fix();

    case 0
        return
end
end
