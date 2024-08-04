//
// File: pixhawk.cpp
//
// Code generated for Simulink model 'pixhawk'.
//
// Model version                  : 1.8
// Simulink Coder version         : 9.6 (R2021b) 14-May-2021
// C/C++ source code generated on : Wed Jan  3 23:17:09 2024
//
// Target selection: ert.tlc
// Embedded hardware selection: ARM Compatible->ARM Cortex
// Code generation objectives: Unspecified
// Validation result: Not run
//
#include "pixhawk.h"
#include "pixhawk_private.h"
#include "pixhawk_dt.h"

// Block signals (default storage)
B_pixhawk_T pixhawk_B;

// Block states (default storage)
DW_pixhawk_T pixhawk_DW;

// Real-time model
RT_MODEL_pixhawk_T pixhawk_M_ = RT_MODEL_pixhawk_T();
RT_MODEL_pixhawk_T *const pixhawk_M = &pixhawk_M_;
real_T rt_atan2d_snf(real_T u0, real_T u1)
{
  real_T y;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = (rtNaN);
  } else if (rtIsInf(u0) && rtIsInf(u1)) {
    int32_T u0_0;
    int32_T u1_0;
    if (u0 > 0.0) {
      u0_0 = 1;
    } else {
      u0_0 = -1;
    }

    if (u1 > 0.0) {
      u1_0 = 1;
    } else {
      u1_0 = -1;
    }

    y = atan2(static_cast<real_T>(u0_0), static_cast<real_T>(u1_0));
  } else if (u1 == 0.0) {
    if (u0 > 0.0) {
      y = RT_PI / 2.0;
    } else if (u0 < 0.0) {
      y = -(RT_PI / 2.0);
    } else {
      y = 0.0;
    }
  } else {
    y = atan2(u0, u1);
  }

  return y;
}

// Model step function
void pixhawk_step(void)
{
  real_T Gain_tmp;
  real_T Gain_tmp_0;
  real_T Gain_tmp_1;
  real_T Gain_tmp_2;
  real_T rtb_fcn3;
  real_T rtb_fcn5;
  boolean_T b_varargout_1;

  // Reset subsysRan breadcrumbs
  srClearBC(pixhawk_DW.EnabledSubsystem_SubsysRanBC);

  // Reset subsysRan breadcrumbs
  srClearBC(pixhawk_DW.IfActionSubsystem_SubsysRanBC);

  // Reset subsysRan breadcrumbs
  srClearBC(pixhawk_DW.IfActionSubsystem1_SubsysRanBC);

  // Reset subsysRan breadcrumbs
  srClearBC(pixhawk_DW.IfActionSubsystem2_SubsysRanBC);

  // MATLABSystem: '<S1>/SourceBlock' incorporates:
  //   Inport: '<S3>/In1'

  b_varargout_1 = uORB_read_step(pixhawk_DW.obj.orbMetadataObj,
    &pixhawk_DW.obj.eventStructObj, &pixhawk_B.b_varargout_2, false, 1.0);

  // Outputs for Enabled SubSystem: '<S1>/Enabled Subsystem' incorporates:
  //   EnablePort: '<S3>/Enable'

  if (b_varargout_1) {
    pixhawk_B.In1 = pixhawk_B.b_varargout_2;
    srUpdateBC(pixhawk_DW.EnabledSubsystem_SubsysRanBC);
  }

  // End of Outputs for SubSystem: '<S1>/Enabled Subsystem'

  // Sqrt: '<S10>/sqrt' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'
  //   Product: '<S11>/Product'
  //   Product: '<S11>/Product1'
  //   Product: '<S11>/Product2'
  //   Product: '<S11>/Product3'
  //   Sum: '<S11>/Sum'

  pixhawk_B.Product3 = sqrt(((static_cast<real_T>(pixhawk_B.In1.q[0]) *
    pixhawk_B.In1.q[0] + static_cast<real_T>(pixhawk_B.In1.q[1]) *
    pixhawk_B.In1.q[1]) + static_cast<real_T>(pixhawk_B.In1.q[2]) *
    pixhawk_B.In1.q[2]) + static_cast<real_T>(pixhawk_B.In1.q[3]) *
    pixhawk_B.In1.q[3]);

  // Product: '<S5>/Product' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'

  rtb_fcn5 = pixhawk_B.In1.q[0] / pixhawk_B.Product3;

  // Product: '<S5>/Product1' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'

  pixhawk_B.Product1 = pixhawk_B.In1.q[1] / pixhawk_B.Product3;

  // Product: '<S5>/Product2' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'

  pixhawk_B.Product2 = pixhawk_B.In1.q[2] / pixhawk_B.Product3;

  // Product: '<S5>/Product3' incorporates:
  //   DataTypeConversion: '<Root>/Data Type Conversion'

  pixhawk_B.Product3 = pixhawk_B.In1.q[3] / pixhawk_B.Product3;

  // Fcn: '<S2>/fcn2' incorporates:
  //   Fcn: '<S2>/fcn5'

  Gain_tmp = rtb_fcn5 * rtb_fcn5;
  Gain_tmp_0 = pixhawk_B.Product1 * pixhawk_B.Product1;
  Gain_tmp_1 = pixhawk_B.Product2 * pixhawk_B.Product2;
  Gain_tmp_2 = pixhawk_B.Product3 * pixhawk_B.Product3;

  // Trigonometry: '<S4>/Trigonometric Function1' incorporates:
  //   Concatenate: '<S4>/Vector Concatenate'
  //   Fcn: '<S2>/fcn1'
  //   Fcn: '<S2>/fcn2'

  pixhawk_B.Gain[0] = rt_atan2d_snf((pixhawk_B.Product1 * pixhawk_B.Product2 +
    rtb_fcn5 * pixhawk_B.Product3) * 2.0, ((Gain_tmp + Gain_tmp_0) - Gain_tmp_1)
    - Gain_tmp_2);

  // Fcn: '<S2>/fcn3'
  rtb_fcn3 = (pixhawk_B.Product1 * pixhawk_B.Product3 - rtb_fcn5 *
              pixhawk_B.Product2) * -2.0;

  // If: '<S6>/If' incorporates:
  //   Constant: '<S7>/Constant'
  //   Constant: '<S8>/Constant'

  if (rtb_fcn3 > 1.0) {
    // Outputs for IfAction SubSystem: '<S6>/If Action Subsystem' incorporates:
    //   ActionPort: '<S7>/Action Port'

    rtb_fcn3 = pixhawk_P.Constant_Value_g;

    // End of Outputs for SubSystem: '<S6>/If Action Subsystem'

    // Update for IfAction SubSystem: '<S6>/If Action Subsystem' incorporates:
    //   ActionPort: '<S7>/Action Port'

    // Update for If: '<S6>/If' incorporates:
    //   Constant: '<S7>/Constant'

    srUpdateBC(pixhawk_DW.IfActionSubsystem_SubsysRanBC);

    // End of Update for SubSystem: '<S6>/If Action Subsystem'
  } else if (rtb_fcn3 < -1.0) {
    // Outputs for IfAction SubSystem: '<S6>/If Action Subsystem1' incorporates:
    //   ActionPort: '<S8>/Action Port'

    rtb_fcn3 = pixhawk_P.Constant_Value_b;

    // End of Outputs for SubSystem: '<S6>/If Action Subsystem1'

    // Update for IfAction SubSystem: '<S6>/If Action Subsystem1' incorporates:
    //   ActionPort: '<S8>/Action Port'

    // Update for If: '<S6>/If' incorporates:
    //   Constant: '<S8>/Constant'

    srUpdateBC(pixhawk_DW.IfActionSubsystem1_SubsysRanBC);

    // End of Update for SubSystem: '<S6>/If Action Subsystem1'
  } else {
    // Update for IfAction SubSystem: '<S6>/If Action Subsystem2' incorporates:
    //   ActionPort: '<S9>/Action Port'

    // Update for If: '<S6>/If'
    srUpdateBC(pixhawk_DW.IfActionSubsystem2_SubsysRanBC);

    // End of Update for SubSystem: '<S6>/If Action Subsystem2'
  }

  // End of If: '<S6>/If'

  // Trigonometry: '<S4>/trigFcn' incorporates:
  //   Concatenate: '<S4>/Vector Concatenate'

  if (rtb_fcn3 > 1.0) {
    rtb_fcn3 = 1.0;
  } else if (rtb_fcn3 < -1.0) {
    rtb_fcn3 = -1.0;
  }

  pixhawk_B.Gain[1] = asin(rtb_fcn3);

  // End of Trigonometry: '<S4>/trigFcn'

  // Trigonometry: '<S4>/Trigonometric Function3' incorporates:
  //   Concatenate: '<S4>/Vector Concatenate'
  //   Fcn: '<S2>/fcn4'
  //   Fcn: '<S2>/fcn5'

  pixhawk_B.Gain[2] = rt_atan2d_snf((pixhawk_B.Product2 * pixhawk_B.Product3 +
    rtb_fcn5 * pixhawk_B.Product1) * 2.0, ((Gain_tmp - Gain_tmp_0) - Gain_tmp_1)
    + Gain_tmp_2);

  // Gain: '<Root>/Gain' incorporates:
  //   Concatenate: '<S4>/Vector Concatenate'

  pixhawk_B.Gain[0] *= pixhawk_P.Gain_Gain;
  pixhawk_B.Gain[1] *= pixhawk_P.Gain_Gain;
  pixhawk_B.Gain[2] *= pixhawk_P.Gain_Gain;

  // Logic: '<S1>/NOT' incorporates:
  //   MATLABSystem: '<S1>/SourceBlock'

  pixhawk_B.NOT = !b_varargout_1;

  // External mode
  rtExtModeUploadCheckTrigger(1);

  {                                    // Sample time: [0.001s, 0.0s]
    rtExtModeUpload(0, (real_T)pixhawk_M->Timing.taskTime0);
  }

  // signal main to stop simulation
  {                                    // Sample time: [0.001s, 0.0s]
    if ((rtmGetTFinal(pixhawk_M)!=-1) &&
        !((rtmGetTFinal(pixhawk_M)-pixhawk_M->Timing.taskTime0) >
          pixhawk_M->Timing.taskTime0 * (DBL_EPSILON))) {
      rtmSetErrorStatus(pixhawk_M, "Simulation finished");
    }

    if (rtmGetStopRequested(pixhawk_M)) {
      rtmSetErrorStatus(pixhawk_M, "Simulation finished");
    }
  }

  // Update absolute time for base rate
  // The "clockTick0" counts the number of times the code of this task has
  //  been executed. The absolute time is the multiplication of "clockTick0"
  //  and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
  //  overflow during the application lifespan selected.

  pixhawk_M->Timing.taskTime0 =
    ((time_T)(++pixhawk_M->Timing.clockTick0)) * pixhawk_M->Timing.stepSize0;
}

// Model initialize function
void pixhawk_initialize(void)
{
  // Registration code

  // initialize non-finites
  rt_InitInfAndNaN(sizeof(real_T));
  rtmSetTFinal(pixhawk_M, -1);
  pixhawk_M->Timing.stepSize0 = 0.001;

  // External mode info
  pixhawk_M->Sizes.checksums[0] = (2324817350U);
  pixhawk_M->Sizes.checksums[1] = (1744414969U);
  pixhawk_M->Sizes.checksums[2] = (1776181033U);
  pixhawk_M->Sizes.checksums[3] = (2546497379U);

  {
    static const sysRanDType rtAlwaysEnabled = SUBSYS_RAN_BC_ENABLE;
    static RTWExtModeInfo rt_ExtModeInfo;
    static const sysRanDType *systemRan[6];
    pixhawk_M->extModeInfo = (&rt_ExtModeInfo);
    rteiSetSubSystemActiveVectorAddresses(&rt_ExtModeInfo, systemRan);
    systemRan[0] = &rtAlwaysEnabled;
    systemRan[1] = (sysRanDType *)&pixhawk_DW.EnabledSubsystem_SubsysRanBC;
    systemRan[2] = &rtAlwaysEnabled;
    systemRan[3] = (sysRanDType *)&pixhawk_DW.IfActionSubsystem_SubsysRanBC;
    systemRan[4] = (sysRanDType *)&pixhawk_DW.IfActionSubsystem1_SubsysRanBC;
    systemRan[5] = (sysRanDType *)&pixhawk_DW.IfActionSubsystem2_SubsysRanBC;
    rteiSetModelMappingInfoPtr(pixhawk_M->extModeInfo,
      &pixhawk_M->SpecialInfo.mappingInfo);
    rteiSetChecksumsPtr(pixhawk_M->extModeInfo, pixhawk_M->Sizes.checksums);
    rteiSetTPtr(pixhawk_M->extModeInfo, rtmGetTPtr(pixhawk_M));
  }

  // data type transition information
  {
    static DataTypeTransInfo dtInfo;
    pixhawk_M->SpecialInfo.mappingInfo = (&dtInfo);
    dtInfo.numDataTypes = 23;
    dtInfo.dataTypeSizes = &rtDataTypeSizes[0];
    dtInfo.dataTypeNames = &rtDataTypeNames[0];

    // Block I/O transition table
    dtInfo.BTransTable = &rtBTransTable;

    // Parameters transition table
    dtInfo.PTransTable = &rtPTransTable;
  }

  // SystemInitialize for Enabled SubSystem: '<S1>/Enabled Subsystem'
  // SystemInitialize for Outport: '<S3>/Out1' incorporates:
  //   Inport: '<S3>/In1'

  pixhawk_B.In1 = pixhawk_P.Out1_Y0;

  // End of SystemInitialize for SubSystem: '<S1>/Enabled Subsystem'

  // Start for MATLABSystem: '<S1>/SourceBlock'
  pixhawk_DW.obj.matlabCodegenIsDeleted = false;
  pixhawk_DW.obj.isSetupComplete = false;
  pixhawk_DW.obj.isInitialized = 1;
  pixhawk_DW.obj.orbMetadataObj = ORB_ID(vehicle_odometry);
  uORB_read_initialize(pixhawk_DW.obj.orbMetadataObj,
                       &pixhawk_DW.obj.eventStructObj);
  pixhawk_DW.obj.isSetupComplete = true;
}

// Model terminate function
void pixhawk_terminate(void)
{
  // Terminate for MATLABSystem: '<S1>/SourceBlock'
  if (!pixhawk_DW.obj.matlabCodegenIsDeleted) {
    pixhawk_DW.obj.matlabCodegenIsDeleted = true;
    if ((pixhawk_DW.obj.isInitialized == 1) && pixhawk_DW.obj.isSetupComplete) {
      uORB_read_terminate(&pixhawk_DW.obj.eventStructObj);
    }
  }

  // End of Terminate for MATLABSystem: '<S1>/SourceBlock'
}

//
// File trailer for generated code.
//
// [EOF]
//
