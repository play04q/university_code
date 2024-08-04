//
//  pixhawk_dt.h
//
//  Code generation for model "pixhawk".
//
//  Model version              : 1.8
//  Simulink Coder version : 9.6 (R2021b) 14-May-2021
//  C++ source code generated on : Wed Jan  3 23:17:09 2024
//
//  Target selection: ert.tlc
//  Embedded hardware selection: ARM Compatible->ARM Cortex
//  Code generation objectives: Unspecified
//  Validation result: Not run


#include "ext_types.h"

// data type size table
static uint_T rtDataTypeSizes[] = {
  sizeof(real_T),
  sizeof(real32_T),
  sizeof(int8_T),
  sizeof(uint8_T),
  sizeof(int16_T),
  sizeof(uint16_T),
  sizeof(int32_T),
  sizeof(uint32_T),
  sizeof(boolean_T),
  sizeof(fcn_call_T),
  sizeof(int_T),
  sizeof(pointer_T),
  sizeof(action_T),
  2*sizeof(uint32_T),
  sizeof(int32_T),
  sizeof(uint64_T),
  sizeof(px4_Bus_vehicle_odometry),
  sizeof(px4_internal_block_Subscriber_T),
  sizeof(uint64_T),
  sizeof(int64_T),
  sizeof(char_T),
  sizeof(uchar_T),
  sizeof(time_T)
};

// data type name table
static const char_T * rtDataTypeNames[] = {
  "real_T",
  "real32_T",
  "int8_T",
  "uint8_T",
  "int16_T",
  "uint16_T",
  "int32_T",
  "uint32_T",
  "boolean_T",
  "fcn_call_T",
  "int_T",
  "pointer_T",
  "action_T",
  "timer_uint32_pair_T",
  "physical_connection",
  "uint64_T",
  "px4_Bus_vehicle_odometry",
  "px4_internal_block_Subscriber_T",
  "uint64_T",
  "int64_T",
  "char_T",
  "uchar_T",
  "time_T"
};

// data type transitions for block I/O structure
static DataTypeTransition rtBTransitions[] = {
  { (char_T *)(&pixhawk_B.In1), 16, 0, 1 },

  { (char_T *)(&pixhawk_B.Gain[0]), 0, 0, 3 },

  { (char_T *)(&pixhawk_B.NOT), 8, 0, 1 }
  ,

  { (char_T *)(&pixhawk_DW.obj), 17, 0, 1 },

  { (char_T *)(&pixhawk_DW.IfActionSubsystem2_SubsysRanBC), 2, 0, 4 }
};

// data type transition table for block I/O structure
static DataTypeTransitionTable rtBTransTable = {
  5U,
  rtBTransitions
};

// data type transitions for Parameters structure
static DataTypeTransition rtPTransitions[] = {
  { (char_T *)(&pixhawk_P.Out1_Y0), 16, 0, 1 },

  { (char_T *)(&pixhawk_P.Constant_Value), 16, 0, 1 },

  { (char_T *)(&pixhawk_P.Constant_Value_g), 0, 0, 3 }
};

// data type transition table for Parameters structure
static DataTypeTransitionTable rtPTransTable = {
  3U,
  rtPTransitions
};

// [EOF] pixhawk_dt.h
