/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern void execute_102(char*, char *);
extern void vlog_const_rhs_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_301(char*, char *);
extern void execute_302(char*, char *);
extern void execute_303(char*, char *);
extern void execute_304(char*, char *);
extern void vlog_simple_process_execute_0_fast_no_reg_no_agg(char*, char*, char*);
extern void execute_258(char*, char *);
extern void execute_259(char*, char *);
extern void execute_261(char*, char *);
extern void execute_262(char*, char *);
extern void execute_263(char*, char *);
extern void execute_265(char*, char *);
extern void execute_266(char*, char *);
extern void execute_267(char*, char *);
extern void execute_268(char*, char *);
extern void execute_269(char*, char *);
extern void execute_270(char*, char *);
extern void execute_271(char*, char *);
extern void execute_272(char*, char *);
extern void execute_273(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_276(char*, char *);
extern void execute_277(char*, char *);
extern void execute_278(char*, char *);
extern void execute_279(char*, char *);
extern void execute_280(char*, char *);
extern void execute_281(char*, char *);
extern void execute_282(char*, char *);
extern void execute_283(char*, char *);
extern void execute_284(char*, char *);
extern void execute_285(char*, char *);
extern void execute_286(char*, char *);
extern void execute_287(char*, char *);
extern void execute_288(char*, char *);
extern void execute_289(char*, char *);
extern void execute_290(char*, char *);
extern void execute_291(char*, char *);
extern void execute_292(char*, char *);
extern void execute_293(char*, char *);
extern void execute_294(char*, char *);
extern void execute_295(char*, char *);
extern void execute_296(char*, char *);
extern void execute_297(char*, char *);
extern void execute_298(char*, char *);
extern void execute_4(char*, char *);
extern void execute_5(char*, char *);
extern void execute_7(char*, char *);
extern void execute_108(char*, char *);
extern void execute_10(char*, char *);
extern void execute_109(char*, char *);
extern void execute_110(char*, char *);
extern void execute_117(char*, char *);
extern void execute_118(char*, char *);
extern void execute_145(char*, char *);
extern void execute_146(char*, char *);
extern void execute_147(char*, char *);
extern void execute_148(char*, char *);
extern void execute_149(char*, char *);
extern void execute_150(char*, char *);
extern void execute_151(char*, char *);
extern void execute_152(char*, char *);
extern void execute_153(char*, char *);
extern void execute_155(char*, char *);
extern void execute_156(char*, char *);
extern void execute_157(char*, char *);
extern void execute_158(char*, char *);
extern void execute_159(char*, char *);
extern void execute_160(char*, char *);
extern void execute_161(char*, char *);
extern void execute_162(char*, char *);
extern void execute_163(char*, char *);
extern void execute_164(char*, char *);
extern void execute_165(char*, char *);
extern void execute_166(char*, char *);
extern void execute_167(char*, char *);
extern void execute_168(char*, char *);
extern void execute_169(char*, char *);
extern void execute_15(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_14(char*, char *);
extern void execute_17(char*, char *);
extern void execute_121(char*, char *);
extern void execute_122(char*, char *);
extern void execute_21(char*, char *);
extern void execute_22(char*, char *);
extern void execute_123(char*, char *);
extern void execute_124(char*, char *);
extern void execute_125(char*, char *);
extern void execute_126(char*, char *);
extern void execute_127(char*, char *);
extern void execute_128(char*, char *);
extern void execute_133(char*, char *);
extern void execute_134(char*, char *);
extern void execute_30(char*, char *);
extern void execute_137(char*, char *);
extern void execute_138(char*, char *);
extern void execute_139(char*, char *);
extern void execute_140(char*, char *);
extern void execute_141(char*, char *);
extern void execute_142(char*, char *);
extern void execute_143(char*, char *);
extern void execute_37(char*, char *);
extern void execute_38(char*, char *);
extern void execute_39(char*, char *);
extern void execute_40(char*, char *);
extern void execute_41(char*, char *);
extern void execute_42(char*, char *);
extern void execute_43(char*, char *);
extern void execute_170(char*, char *);
extern void execute_171(char*, char *);
extern void execute_172(char*, char *);
extern void execute_174(char*, char *);
extern void execute_49(char*, char *);
extern void execute_68(char*, char *);
extern void execute_175(char*, char *);
extern void execute_176(char*, char *);
extern void execute_177(char*, char *);
extern void execute_199(char*, char *);
extern void execute_200(char*, char *);
extern void execute_201(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_204(char*, char *);
extern void execute_205(char*, char *);
extern void execute_206(char*, char *);
extern void execute_178(char*, char *);
extern void execute_179(char*, char *);
extern void execute_185(char*, char *);
extern void execute_186(char*, char *);
extern void execute_187(char*, char *);
extern void execute_188(char*, char *);
extern void execute_189(char*, char *);
extern void execute_192(char*, char *);
extern void execute_193(char*, char *);
extern void execute_194(char*, char *);
extern void execute_195(char*, char *);
extern void execute_196(char*, char *);
extern void execute_197(char*, char *);
extern void execute_57(char*, char *);
extern void execute_59(char*, char *);
extern void execute_181(char*, char *);
extern void execute_182(char*, char *);
extern void execute_183(char*, char *);
extern void execute_184(char*, char *);
extern void execute_65(char*, char *);
extern void execute_67(char*, char *);
extern void execute_72(char*, char *);
extern void execute_74(char*, char *);
extern void execute_209(char*, char *);
extern void execute_211(char*, char *);
extern void execute_212(char*, char *);
extern void execute_239(char*, char *);
extern void execute_240(char*, char *);
extern void execute_241(char*, char *);
extern void execute_242(char*, char *);
extern void execute_243(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_246(char*, char *);
extern void execute_247(char*, char *);
extern void execute_248(char*, char *);
extern void execute_249(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_252(char*, char *);
extern void execute_253(char*, char *);
extern void execute_254(char*, char *);
extern void execute_255(char*, char *);
extern void execute_256(char*, char *);
extern void execute_257(char*, char *);
extern void execute_78(char*, char *);
extern void execute_80(char*, char *);
extern void execute_213(char*, char *);
extern void execute_214(char*, char *);
extern void execute_215(char*, char *);
extern void execute_216(char*, char *);
extern void execute_217(char*, char *);
extern void execute_218(char*, char *);
extern void execute_219(char*, char *);
extern void execute_220(char*, char *);
extern void execute_84(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_225(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_223(char*, char *);
extern void execute_224(char*, char *);
extern void execute_228(char*, char *);
extern void execute_229(char*, char *);
extern void execute_88(char*, char *);
extern void execute_89(char*, char *);
extern void execute_230(char*, char *);
extern void execute_97(char*, char *);
extern void execute_235(char*, char *);
extern void execute_236(char*, char *);
extern void execute_237(char*, char *);
extern void execute_238(char*, char *);
extern void execute_104(char*, char *);
extern void execute_105(char*, char *);
extern void execute_106(char*, char *);
extern void execute_305(char*, char *);
extern void execute_306(char*, char *);
extern void execute_307(char*, char *);
extern void execute_308(char*, char *);
extern void execute_309(char*, char *);
extern void vlog_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_19(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_20(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_22(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_49(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_97(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_100(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_102(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_115(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_118(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_119(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_124(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_186(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_189(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_190(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_191(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_239(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_241(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_247(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_248(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_255(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[230] = {(funcp)execute_102, (funcp)vlog_const_rhs_process_execute_0_fast_no_reg_no_agg, (funcp)execute_301, (funcp)execute_302, (funcp)execute_303, (funcp)execute_304, (funcp)vlog_simple_process_execute_0_fast_no_reg_no_agg, (funcp)execute_258, (funcp)execute_259, (funcp)execute_261, (funcp)execute_262, (funcp)execute_263, (funcp)execute_265, (funcp)execute_266, (funcp)execute_267, (funcp)execute_268, (funcp)execute_269, (funcp)execute_270, (funcp)execute_271, (funcp)execute_272, (funcp)execute_273, (funcp)execute_274, (funcp)execute_275, (funcp)execute_276, (funcp)execute_277, (funcp)execute_278, (funcp)execute_279, (funcp)execute_280, (funcp)execute_281, (funcp)execute_282, (funcp)execute_283, (funcp)execute_284, (funcp)execute_285, (funcp)execute_286, (funcp)execute_287, (funcp)execute_288, (funcp)execute_289, (funcp)execute_290, (funcp)execute_291, (funcp)execute_292, (funcp)execute_293, (funcp)execute_294, (funcp)execute_295, (funcp)execute_296, (funcp)execute_297, (funcp)execute_298, (funcp)execute_4, (funcp)execute_5, (funcp)execute_7, (funcp)execute_108, (funcp)execute_10, (funcp)execute_109, (funcp)execute_110, (funcp)execute_117, (funcp)execute_118, (funcp)execute_145, (funcp)execute_146, (funcp)execute_147, (funcp)execute_148, (funcp)execute_149, (funcp)execute_150, (funcp)execute_151, (funcp)execute_152, (funcp)execute_153, (funcp)execute_155, (funcp)execute_156, (funcp)execute_157, (funcp)execute_158, (funcp)execute_159, (funcp)execute_160, (funcp)execute_161, (funcp)execute_162, (funcp)execute_163, (funcp)execute_164, (funcp)execute_165, (funcp)execute_166, (funcp)execute_167, (funcp)execute_168, (funcp)execute_169, (funcp)execute_15, (funcp)execute_119, (funcp)execute_120, (funcp)execute_14, (funcp)execute_17, (funcp)execute_121, (funcp)execute_122, (funcp)execute_21, (funcp)execute_22, (funcp)execute_123, (funcp)execute_124, (funcp)execute_125, (funcp)execute_126, (funcp)execute_127, (funcp)execute_128, (funcp)execute_133, (funcp)execute_134, (funcp)execute_30, (funcp)execute_137, (funcp)execute_138, (funcp)execute_139, (funcp)execute_140, (funcp)execute_141, (funcp)execute_142, (funcp)execute_143, (funcp)execute_37, (funcp)execute_38, (funcp)execute_39, (funcp)execute_40, (funcp)execute_41, (funcp)execute_42, (funcp)execute_43, (funcp)execute_170, (funcp)execute_171, (funcp)execute_172, (funcp)execute_174, (funcp)execute_49, (funcp)execute_68, (funcp)execute_175, (funcp)execute_176, (funcp)execute_177, (funcp)execute_199, (funcp)execute_200, (funcp)execute_201, (funcp)execute_202, (funcp)execute_203, (funcp)execute_204, (funcp)execute_205, (funcp)execute_206, (funcp)execute_178, (funcp)execute_179, (funcp)execute_185, (funcp)execute_186, (funcp)execute_187, (funcp)execute_188, (funcp)execute_189, (funcp)execute_192, (funcp)execute_193, (funcp)execute_194, (funcp)execute_195, (funcp)execute_196, (funcp)execute_197, (funcp)execute_57, (funcp)execute_59, (funcp)execute_181, (funcp)execute_182, (funcp)execute_183, (funcp)execute_184, (funcp)execute_65, (funcp)execute_67, (funcp)execute_72, (funcp)execute_74, (funcp)execute_209, (funcp)execute_211, (funcp)execute_212, (funcp)execute_239, (funcp)execute_240, (funcp)execute_241, (funcp)execute_242, (funcp)execute_243, (funcp)execute_244, (funcp)execute_245, (funcp)execute_246, (funcp)execute_247, (funcp)execute_248, (funcp)execute_249, (funcp)execute_250, (funcp)execute_251, (funcp)execute_252, (funcp)execute_253, (funcp)execute_254, (funcp)execute_255, (funcp)execute_256, (funcp)execute_257, (funcp)execute_78, (funcp)execute_80, (funcp)execute_213, (funcp)execute_214, (funcp)execute_215, (funcp)execute_216, (funcp)execute_217, (funcp)execute_218, (funcp)execute_219, (funcp)execute_220, (funcp)execute_84, (funcp)execute_221, (funcp)execute_222, (funcp)execute_225, (funcp)execute_226, (funcp)execute_227, (funcp)execute_223, (funcp)execute_224, (funcp)execute_228, (funcp)execute_229, (funcp)execute_88, (funcp)execute_89, (funcp)execute_230, (funcp)execute_97, (funcp)execute_235, (funcp)execute_236, (funcp)execute_237, (funcp)execute_238, (funcp)execute_104, (funcp)execute_105, (funcp)execute_106, (funcp)execute_305, (funcp)execute_306, (funcp)execute_307, (funcp)execute_308, (funcp)execute_309, (funcp)vlog_transfunc_eventcallback, (funcp)transaction_19, (funcp)transaction_20, (funcp)transaction_22, (funcp)transaction_49, (funcp)transaction_97, (funcp)transaction_100, (funcp)transaction_102, (funcp)transaction_115, (funcp)transaction_118, (funcp)transaction_119, (funcp)transaction_124, (funcp)transaction_186, (funcp)transaction_189, (funcp)transaction_190, (funcp)transaction_191, (funcp)transaction_239, (funcp)transaction_241, (funcp)transaction_247, (funcp)transaction_248, (funcp)transaction_255};
const int NumRelocateId= 230;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/TestMotherboard_behav/xsim.reloc",  (void **)funcTab, 230);

	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/TestMotherboard_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/TestMotherboard_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 10485760) ;
    iki_set_sv_type_file_path_name("xsim.dir/TestMotherboard_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/TestMotherboard_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/TestMotherboard_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
