//
// File: pixhawk.h
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
#ifndef RTW_HEADER_pixhawk_h_
#define RTW_HEADER_pixhawk_h_
#include <math.h>
#include <float.h>
#include <stddef.h>
#include <poll.h>
#include <uORB/uORB.h>
#include "rtwtypes.h"
#include "rtw_extmode.h"
#include "sysran_types.h"
#include "dt_info.h"
#include "ext_work.h"
#include "MW_uORB_Read.h"
#include "pixhawk_types.h"

// Shared type includes
#include "multiword_types.h"
#include "rt_defines.h"
#include "rt_nonfinite.h"
#include "rtGetInf.h"

// Macros for accessing real-time model data structure
#ifndef rtmGetFinalTime
#define rtmGetFinalTime(rtm)           ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetRTWExtModeInfo
#define rtmGetRTWExtModeInfo(rtm)      ((rtm)->extModeInfo)
#endif

#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   ((rtm)->Timing.taskTime0)
#endif

#ifndef rtmGetTFinal
#define rtmGetTFinal(rtm)              ((rtm)->Timing.tFinal)
#endif

#ifndef rtmGetTPtr
#define rtmGetTPtr(rtm)                (&(rtm)->Timing.taskTime0)
#endif

// Block signals (default storage)
struct B_pixhawk_T {
  px4_Bus_vehicle_odometry In1;        // '<S3>/In1'
  px4_Bus_vehicle_odometry b_varargout_2;
  real_T Gain[3];                      // '<Root>/Gain'
  real_T Product3;                     // '<S5>/Product3'
  real_T Product2;                     // '<S5>/Product2'
  real_T Product1;                     // '<S5>/Product1'
  boolean_T NOT;                       // '<S1>/NOT'
};

// Block states (default storage) for system '<Root>'
struct DW_pixhawk_T {
  px4_internal_block_Subscriber_T obj; // '<S1>/SourceBlock'
  int8_T IfActionSubsystem2_SubsysRanBC;// '<S6>/If Action Subsystem2'
  int8_T IfActionSubsystem1_SubsysRanBC;// '<S6>/If Action Subsystem1'
  int8_T IfActionSubsystem_SubsysRanBC;// '<S6>/If Action Subsystem'
  int8_T EnabledSubsystem_SubsysRanBC; // '<S1>/Enabled Subsystem'
};

// Parameters (default storage)
struct P_pixhawk_T_ {
  px4_Bus_vehicle_odometry Out1_Y0;    // Computed Parameter: Out1_Y0
                                          //  Referenced by: '<S3>/Out1'

  px4_Bus_vehicle_odometry Constant_Value;// Computed Parameter: Constant_Value
                                             //  Referenced by: '<S1>/Constant'

  real_T Constant_Value_g;             // Expression: 1
                                          //  Referenced by: '<S7>/Constant'

  real_T Constant_Value_b;             // Expression: 1
                                          //  Referenced by: '<S8>/Constant'

  real_T Gain_Gain;                    // Expression: 180/pi
                                          //  Referenced by: '<Root>/Gain'

};

// Real-time Model Data Structure
struct tag_RTM_pixhawk_T {
  const char_T *errorStatus;
  RTWExtModeInfo *extModeInfo;

  //
  //  Sizes:
  //  The following substructure contains sizes information
  //  for many of the model attributes such as inputs, outputs,
  //  dwork, sample times, etc.

  struct {
    uint32_T checksums[4];
  } Sizes;

  //
  //  SpecialInfo:
  //  The following substructure contains special information
  //  related to other components that are dependent on RTW.

  struct {
    const void *mappingInfo;
  } SpecialInfo;

  //
  //  Timing:
  //  The following substructure contains information regarding
  //  the timing information for the model.

  struct {
    time_T taskTime0;
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tFinal;
    boolean_T stopRequestedFlag;
  } Timing;
};

// Block parameters (default storage)
#ifdef __cplusplus

extern "C" {

#endif

  extern P_pixhawk_T pixhawk_P;

#ifdef __cplusplus

}
#endif

// Block signals (default storage)
#ifdef __cplusplus

extern "C" {

#endif

  extern struct B_pixhawk_T pixhawk_B;

#ifdef __cplusplus

}
#endif

// Block states (default storage)
extern struct DW_pixhawk_T pixhawk_DW;

#ifdef __cplusplus

extern "C" {

#endif

  // Model entry point functions
  extern void pixhawk_initialize(void);
  extern void pixhawk_step(void);
  extern void pixhawk_terminate(void);

#ifdef __cplusplus

}
#endif

// Real-time Model object
#ifdef __cplusplus

extern "C" {

#endif

  extern RT_MODEL_pixhawk_T *const pixhawk_M;

#ifdef __cplusplus

}
#endif

//-
//  The generated code includes comments that allow you to trace directly
//  back to the appropriate location in the model.  The basic format
//  is <system>/block_name, where system is the system number (uniquely
//  assigned by Simulink) and block_name is the name of the block.
//
//  Use the MATLAB hilite_system command to trace the generated code back
//  to the model.  For example,
//
//  hilite_system('<S3>')    - opens system 3
//  hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
//
//  Here is the system hierarchy for this model
//
//  '<Root>' : 'pixhawk'
//  '<S1>'   : 'pixhawk/PX4 uORB Read'
//  '<S2>'   : 'pixhawk/Quaternions to Rotation Angles'
//  '<S3>'   : 'pixhawk/PX4 uORB Read/Enabled Subsystem'
//  '<S4>'   : 'pixhawk/Quaternions to Rotation Angles/Angle Calculation'
//  '<S5>'   : 'pixhawk/Quaternions to Rotation Angles/Quaternion Normalize'
//  '<S6>'   : 'pixhawk/Quaternions to Rotation Angles/Angle Calculation/Protect asincos input'
//  '<S7>'   : 'pixhawk/Quaternions to Rotation Angles/Angle Calculation/Protect asincos input/If Action Subsystem'
//  '<S8>'   : 'pixhawk/Quaternions to Rotation Angles/Angle Calculation/Protect asincos input/If Action Subsystem1'
//  '<S9>'   : 'pixhawk/Quaternions to Rotation Angles/Angle Calculation/Protect asincos input/If Action Subsystem2'
//  '<S10>'  : 'pixhawk/Quaternions to Rotation Angles/Quaternion Normalize/Quaternion Modulus'
//  '<S11>'  : 'pixhawk/Quaternions to Rotation Angles/Quaternion Normalize/Quaternion Modulus/Quaternion Norm'

#endif                                 // RTW_HEADER_pixhawk_h_

//
// File trailer for generated code.
//
// [EOF]
//
