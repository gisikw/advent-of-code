/*
** Automatically generated from `solution.m'
** by the Mercury compiler,
** version 22.01.8
** configured for aarch64-apple-darwin24.4.0.
** Do not edit.
**
** The autoconfigured grade settings governing
** the generation of this C file were
**
** TAG_BITS=3
** UNBOXED_FLOAT=yes
** UNBOXED_INT64S=yes
** PREGENERATED_DIST=no
** HIGHLEVEL_CODE=yes
**
** END_OF_C_GRADE_INFO
*/


// :- module solution.
// :- implementation.

/*
INIT mercury__solution__init
ENDINIT
*/

#include "solution.mih"


#include "array.mih"
#include "assoc_list.mih"
#include "bitmap.mih"
#include "bool.mih"
#include "builtin.mih"
#include "char.mih"
#include "construct.mih"
#include "deconstruct.mih"
#include "enum.mih"
#include "int.mih"
#include "io.mih"
#include "list.mih"
#include "map.mih"
#include "maybe.mih"
#include "ops.mih"
#include "pair.mih"
#include "pretty_printer.mih"
#include "private_builtin.mih"
#include "require.mih"
#include "stream.mih"
#include "string.mih"
#include "term.mih"
#include "time.mih"
#include "tree234.mih"
#include "type_desc.mih"
#include "univ.mih"
#include "string.format.mih"
#include "string.parse_util.mih"




static MR_Integer MR_CALL 
solution__fits_1_f_0(
  MR_String Line_3);

static void MR_CALL 
solution__sum_3_p_0(
  MR_Integer X_4,
  MR_Integer Y_5,
  MR_Integer * Result_6);

static void MR_CALL 
main_2_p_0_2(
  MR_Box closure_arg,
  MR_Box wrapper_arg_1,
  MR_Box wrapper_arg_2,
  MR_Box * wrapper_arg_3);

static MR_Box MR_CALL 
main_2_p_0_1(
  MR_Box closure_arg,
  MR_Box wrapper_arg_1);


static /* final */ const MR_Box solution_scalar_common_1[1][1];

static /* final */ const MR_Box solution_scalar_common_2[1][5];

static /* final */ const MR_Box solution_scalar_common_3[2][3];

static /* final */ const MR_Box solution_scalar_common_4[1][6];




static /* final */ const MR_Box solution_scalar_common_1[1][1] = {
  /* row 0 */
  {
    (MR_Box) (((((MR_Unsigned) 0U << 4)) | (((((MR_Unsigned) 0U << 3)) | (((((MR_Unsigned) 0U << 2)) | (((MR_Unsigned) 0U << 1))))))))
  },
};

static /* final */ const MR_Box solution_scalar_common_2[1][5] = {
  /* row 0 */
  {
    NULL,
    ((MR_Box) (NULL)),
    ((MR_Box) ((MR_Integer) 2)),
    ((MR_Box) (&mercury__builtin__builtin__type_ctor_info_string_0)),
    ((MR_Box) (&mercury__builtin__builtin__type_ctor_info_int_0))
  },
};

static /* final */ const MR_Box solution_scalar_common_3[2][3] = {
  /* row 0 */
  {
    ((MR_Box) (&solution_scalar_common_2[0])),
    ((MR_Box) (main_2_p_0_1)),
    ((MR_Box) ((MR_Integer) 0))
  },
  /* row 1 */
  {
    ((MR_Box) (&solution_scalar_common_4[0])),
    ((MR_Box) (main_2_p_0_2)),
    ((MR_Box) ((MR_Integer) 0))
  },
};

static /* final */ const MR_Box solution_scalar_common_4[1][6] = {
  /* row 0 */
  {
    NULL,
    ((MR_Box) (NULL)),
    ((MR_Box) ((MR_Integer) 3)),
    ((MR_Box) (&mercury__builtin__builtin__type_ctor_info_int_0)),
    ((MR_Box) (&mercury__builtin__builtin__type_ctor_info_int_0)),
    ((MR_Box) (&mercury__builtin__builtin__type_ctor_info_int_0))
  },
};



#include "array.mh"
#include "bitmap.mh"
#include "io.mh"
#include "string.mh"
#include "time.mh"



static MR_Integer MR_CALL 
solution__fits_1_f_0(
  MR_String Line_3)
{
  {
    MR_bool succeeded;
    MR_Integer Result_4;
    MR_String AreaStr_5;
    MR_String PieceStr_6;
    MR_Word Var_7;
    MR_String Var_8 = (MR_String) ": ";
    MR_Word Var_9;
    MR_Word Var_10;

    Var_7 = mercury__string__split_at_string_2_f_0(Var_8, Line_3);
    succeeded = (Var_7 != (MR_Word) ((MR_Unsigned) 0U));
    if (succeeded)
    {
      AreaStr_5 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_7, (MR_Integer) 0))));
      Var_9 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_7, (MR_Integer) 1))));
      succeeded = (Var_9 != (MR_Word) ((MR_Unsigned) 0U));
      if (succeeded)
      {
        PieceStr_6 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_9, (MR_Integer) 0))));
        Var_10 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_9, (MR_Integer) 1))));
        succeeded = (Var_10 == (MR_Word) ((MR_Unsigned) 0U));
      }
    }
    if (succeeded)
    {
      MR_Integer Var_11;
      MR_Integer Var_12;
      MR_Integer X_18;
      MR_Integer Y_19;
      MR_String XStr_16;
      MR_String YStr_17;
      MR_Word Var_20;
      MR_String Var_21 = (MR_String) "x";
      MR_Word Var_22;
      MR_Word Var_23;
      MR_Integer A_33;
      MR_Integer B_34;
      MR_Integer C_35;
      MR_Integer D_36;
      MR_Integer E_37;
      MR_Integer F_38;
      MR_String AStr_27;
      MR_String BStr_28;
      MR_String CStr_29;
      MR_String DStr_30;
      MR_String EStr_31;
      MR_String FStr_32;
      MR_Word Var_39;
      MR_String Var_40;
      MR_Word Var_41;
      MR_Word Var_42;
      MR_Word Var_43;
      MR_Word Var_44;
      MR_Word Var_45;
      MR_Word Var_46;

      Var_20 = mercury__string__split_at_string_2_f_0(Var_21, AreaStr_5);
      succeeded = (Var_20 != (MR_Word) ((MR_Unsigned) 0U));
      if (succeeded)
      {
        XStr_16 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_20, (MR_Integer) 0))));
        Var_22 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_20, (MR_Integer) 1))));
        succeeded = (Var_22 != (MR_Word) ((MR_Unsigned) 0U));
        if (succeeded)
        {
          YStr_17 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_22, (MR_Integer) 0))));
          Var_23 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_22, (MR_Integer) 1))));
          succeeded = (Var_23 == (MR_Word) ((MR_Unsigned) 0U));
          if (succeeded)
          {
            succeeded = mercury__string__to_int_2_p_0(XStr_16, &X_18);
            if (succeeded)
              succeeded = mercury__string__to_int_2_p_0(YStr_17, &Y_19);
          }
        }
      }
      if (succeeded)
        Var_11 = (MR_Integer) ((MR_Unsigned) X_18 * (MR_Unsigned) Y_19);
      else
      {
        MR_String Var_24 = (MR_String) "this won\'t happen";

        mercury__require__error_1_p_0(Var_24);
      }
      Var_40 = (MR_String) " ";
      Var_39 = mercury__string__split_at_string_2_f_0(Var_40, PieceStr_6);
      succeeded = (Var_39 != (MR_Word) ((MR_Unsigned) 0U));
      if (succeeded)
      {
        AStr_27 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_39, (MR_Integer) 0))));
        Var_41 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_39, (MR_Integer) 1))));
        succeeded = (Var_41 != (MR_Word) ((MR_Unsigned) 0U));
        if (succeeded)
        {
          BStr_28 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_41, (MR_Integer) 0))));
          Var_42 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_41, (MR_Integer) 1))));
          succeeded = (Var_42 != (MR_Word) ((MR_Unsigned) 0U));
          if (succeeded)
          {
            CStr_29 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_42, (MR_Integer) 0))));
            Var_43 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_42, (MR_Integer) 1))));
            succeeded = (Var_43 != (MR_Word) ((MR_Unsigned) 0U));
            if (succeeded)
            {
              DStr_30 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_43, (MR_Integer) 0))));
              Var_44 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_43, (MR_Integer) 1))));
              succeeded = (Var_44 != (MR_Word) ((MR_Unsigned) 0U));
              if (succeeded)
              {
                EStr_31 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_44, (MR_Integer) 0))));
                Var_45 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_44, (MR_Integer) 1))));
                succeeded = (Var_45 != (MR_Word) ((MR_Unsigned) 0U));
                if (succeeded)
                {
                  FStr_32 = ((MR_String) ((MR_hl_field(MR_mktag(1), Var_45, (MR_Integer) 0))));
                  Var_46 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_45, (MR_Integer) 1))));
                  succeeded = (Var_46 == (MR_Word) ((MR_Unsigned) 0U));
                  if (succeeded)
                  {
                    succeeded = mercury__string__to_int_2_p_0(AStr_27, &A_33);
                    if (succeeded)
                    {
                      succeeded = mercury__string__to_int_2_p_0(BStr_28, &B_34);
                      if (succeeded)
                      {
                        succeeded = mercury__string__to_int_2_p_0(CStr_29, &C_35);
                        if (succeeded)
                        {
                          succeeded = mercury__string__to_int_2_p_0(DStr_30, &D_36);
                          if (succeeded)
                          {
                            succeeded = mercury__string__to_int_2_p_0(EStr_31, &E_37);
                            if (succeeded)
                              succeeded = mercury__string__to_int_2_p_0(FStr_32, &F_38);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      if (succeeded)
      {
        MR_Integer Var_47;
        MR_Integer Var_48;
        MR_Integer Var_49;
        MR_Integer Var_50;
        MR_Integer Var_51;
        MR_Integer Var_52 = (MR_Integer) 5;
        MR_Integer Var_53;
        MR_Integer Var_54;
        MR_Integer Var_55;
        MR_Integer Var_56;
        MR_Integer Var_57;
        MR_Integer Var_58;
        MR_Integer Var_59;
        MR_Integer Var_60;
        MR_Integer Var_61;
        MR_Integer Var_62;

        Var_51 = (MR_Integer) ((MR_Unsigned) A_33 * (MR_Unsigned) Var_52);
        Var_54 = (MR_Integer) 7;
        Var_53 = (MR_Integer) ((MR_Unsigned) B_34 * (MR_Unsigned) Var_54);
        Var_50 = (MR_Integer) ((MR_Unsigned) Var_51 + (MR_Unsigned) Var_53);
        Var_56 = (MR_Integer) 7;
        Var_55 = (MR_Integer) ((MR_Unsigned) C_35 * (MR_Unsigned) Var_56);
        Var_49 = (MR_Integer) ((MR_Unsigned) Var_50 + (MR_Unsigned) Var_55);
        Var_58 = (MR_Integer) 7;
        Var_57 = (MR_Integer) ((MR_Unsigned) D_36 * (MR_Unsigned) Var_58);
        Var_48 = (MR_Integer) ((MR_Unsigned) Var_49 + (MR_Unsigned) Var_57);
        Var_60 = (MR_Integer) 7;
        Var_59 = (MR_Integer) ((MR_Unsigned) E_37 * (MR_Unsigned) Var_60);
        Var_47 = (MR_Integer) ((MR_Unsigned) Var_48 + (MR_Unsigned) Var_59);
        Var_62 = (MR_Integer) 7;
        Var_61 = (MR_Integer) ((MR_Unsigned) F_38 * (MR_Unsigned) Var_62);
        Var_12 = (MR_Integer) ((MR_Unsigned) Var_47 + (MR_Unsigned) Var_61);
      }
      else
      {
        MR_String Var_63 = (MR_String) "this won\'t happen";

        mercury__require__error_1_p_0(Var_63);
      }
      succeeded = (Var_11 >= Var_12);
      if (succeeded)
        Result_4 = (MR_Integer) 1;
      else
        Result_4 = (MR_Integer) 0;
    }
    else
    {
      MR_String Var_13 = (MR_String) "this won\'t happen";

      mercury__require__error_1_p_0(Var_13);
    }
    return Result_4;
  }
}

static void MR_CALL 
solution__sum_3_p_0(
  MR_Integer X_4,
  MR_Integer Y_5,
  MR_Integer * Result_6)
{
  *Result_6 = (MR_Integer) ((MR_Unsigned) X_4 + (MR_Unsigned) Y_5);
}

static void MR_CALL 
main_2_p_0_2(
  MR_Box closure_arg,
  MR_Box wrapper_arg_1,
  MR_Box wrapper_arg_2,
  MR_Box * wrapper_arg_3)
{
  {
    MR_Box closure = closure_arg;
    MR_Integer conv1_Result_6;

    solution__sum_3_p_0(((MR_Integer) (wrapper_arg_1)), ((MR_Integer) (wrapper_arg_2)), &conv1_Result_6);
    *wrapper_arg_3 = ((MR_Box) (conv1_Result_6));
  }
}

static MR_Box MR_CALL 
main_2_p_0_1(
  MR_Box closure_arg,
  MR_Box wrapper_arg_1)
{
  {
    MR_Box wrapper_arg_2;
    MR_Box closure = closure_arg;
    MR_Integer conv0_Result_4;

    conv0_Result_4 = solution__fits_1_f_0(((MR_String) (wrapper_arg_1)));
    wrapper_arg_2 = ((MR_Box) (conv0_Result_4));
    return wrapper_arg_2;
  }
}

void MR_CALL 
main_2_p_0(void)
{
  {
    MR_bool succeeded;
    MR_Word Args_4;
    MR_String InputFile_5;
    MR_Word Var_15;
    MR_Word Var_16;

    mercury__io__command_line_arguments_3_p_0(&Args_4);
    succeeded = (Args_4 != (MR_Word) ((MR_Unsigned) 0U));
    if (succeeded)
    {
      InputFile_5 = ((MR_String) ((MR_hl_field(MR_mktag(1), Args_4, (MR_Integer) 0))));
      Var_15 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Args_4, (MR_Integer) 1))));
      succeeded = (Var_15 != (MR_Word) ((MR_Unsigned) 0U));
      if (succeeded)
      {
        Var_16 = ((MR_Word) ((MR_hl_field(MR_mktag(1), Var_15, (MR_Integer) 1))));
        succeeded = (Var_16 == (MR_Word) ((MR_Unsigned) 0U));
      }
    }
    if (succeeded)
    {
      MR_Word Result_7;
      MR_Word Lines_8;

      mercury__io__read_named_file_as_lines_4_p_0(InputFile_5, &Result_7);
      succeeded = ((MR_tag((MR_Word) Result_7)) == (MR_Integer) 0);
      if (succeeded)
      {
        Lines_8 = ((MR_Word) ((MR_hl_field(MR_mktag(0), Result_7, (MR_Integer) 0))));
        {
          MR_Word TypeCtorInfo_29_29 = (MR_Word) (&mercury__builtin__builtin__type_ctor_info_string_0);
          MR_Word TypeCtorInfo_30_30;
          MR_Word PuzzleLines_9;
          MR_Word Results_10;
          MR_Integer Sum_11;
          MR_Integer Var_18 = (MR_Integer) 30;
          MR_Word Var_19;
          MR_Word Var_20;
          MR_Integer Var_21;
          MR_String Var_37;
          MR_Word Var_43;
          MR_String Var_44;
          MR_Box conv2_Sum_11;

          mercury__list__det_drop_3_p_0(TypeCtorInfo_29_29, Var_18, Lines_8, &PuzzleLines_9);
          TypeCtorInfo_30_30 = (MR_Word) (&mercury__builtin__builtin__type_ctor_info_int_0);
          Var_19 = (MR_Word) (&solution_scalar_common_3[0]);
          Results_10 = mercury__list__map_2_f_0(TypeCtorInfo_29_29, TypeCtorInfo_30_30, Var_19, PuzzleLines_9);
          Var_20 = (MR_Word) (&solution_scalar_common_3[1]);
          Var_21 = (MR_Integer) 0;
          mercury__list__foldl_4_p_0(TypeCtorInfo_30_30, TypeCtorInfo_30_30, Var_20, Results_10, ((MR_Box) (Var_21)), &conv2_Sum_11);
          Sum_11 = ((MR_Integer) (conv2_Sum_11));
          Var_43 = (MR_Word) (&solution_scalar_common_1[0]);
          mercury__string__format__format_signed_int_component_nowidth_noprec_3_p_0(Var_43, Sum_11, &Var_37);
          mercury__io__write_string_3_p_0(Var_37);
          Var_44 = (MR_String) "\n";
          mercury__io__write_string_3_p_0(Var_44);
        }
      }
      else
      {
        MR_String Var_27 = (MR_String) "this won\'t happen";

        {
          mercury__require__error_1_p_0(Var_27);
          return;
        }
      }
    }
    else
    {
      MR_String Var_28 = (MR_String) "this won\'t happen";

      {
        mercury__require__error_1_p_0(Var_28);
        return;
      }
    }
  }
}

void mercury__solution__init(void)
{
}

void mercury__solution__init_type_tables(void)
{
}

void mercury__solution__init_debugger(void)
{
	MR_fatal_error("debugger initialization in MLDS grade");
}

// Ensure everything is compiled with the same grade.
const char *mercury__solution__grade_check(void)
{
    return &MR_GRADE_VAR;
}

// :- end_module solution.
