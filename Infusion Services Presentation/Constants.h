//
//  Constants.h
//  Infusion Services Presentation
//
//  Created by Patrick Pierson on 12/5/13.
//  Copyright (c) 2013 Local Wisdom Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBER_OF_STAFF_TYPE 2
#define NUMBER_OF_DAYS 7
#define NUMBER_OF_TEN_MINUTE_PERIODS_IN_DAY 144

#ifdef DEBUG
#define DEBUGMODE YES
#else
#define DEBUGMODE NO
#endif

//Default remicade times for remicade infusion
extern int const DEFAULT_REM2HR_PREP1_TIME;
extern int const DEFAULT_REM2HR_PREP2_TIME;
extern int const DEFAULT_REM2HR_INFUSION_MAKE_TIME;
extern int const DEFAULT_REM2HR_POST1_TIME;
extern int const DEFAULT_REM2HR_POST2_TIME;

extern int const DEFAULT_REM25HR_PREP1_TIME;
extern int const DEFAULT_REM25HR_PREP2_TIME;
extern int const DEFAULT_REM25HR_INFUSION_MAKE_TIME;
extern int const DEFAULT_REM25HR_POST1_TIME;
extern int const DEFAULT_REM25HR_POST2_TIME;

extern int const DEFAULT_REM3HR_PREP1_TIME;
extern int const DEFAULT_REM3HR_PREP2_TIME;
extern int const DEFAULT_REM3HR_INFUSION_MAKE_TIME;
extern int const DEFAULT_REM3HR_POST1_TIME;
extern int const DEFAULT_REM3HR_POST2_TIME;

extern int const DEFAULT_REM35HR_PREP1_TIME;
extern int const DEFAULT_REM35HR_PREP2_TIME;
extern int const DEFAULT_REM35HR_INFUSION_MAKE_TIME;
extern int const DEFAULT_REM35HR_POST1_TIME;
extern int const DEFAULT_REM35HR_POST2_TIME;

extern int const DEFAULT_REM4HR_PREP1_TIME;
extern int const DEFAULT_REM4HR_PREP2_TIME;
extern int const DEFAULT_REM4HR_INFUSION_MAKE_TIME;
extern int const DEFAULT_REM4HR_POST1_TIME;
extern int const DEFAULT_REM4HR_POST2_TIME;

//Default times for other infusions
extern int const DEFAULT_RXA_PREP1_TIME;
extern int const DEFAULT_RXA_PREP2_TIME;
extern int const DEFAULT_RXA_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXA_POST1_TIME;
extern int const DEFAULT_RXA_POST2_TIME;
extern int const DEFAULT_RXA_WEEKS_BETWEEN;

extern int const DEFAULT_RXB_PREP1_TIME;
extern int const DEFAULT_RXB_PREP2_TIME;
extern int const DEFAULT_RXB_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXB_POST1_TIME;
extern int const DEFAULT_RXB_POST2_TIME;
extern int const DEFAULT_RXB_WEEKS_BETWEEN;

extern int const DEFAULT_RXC_PREP1_TIME;
extern int const DEFAULT_RXC_PREP2_TIME;
extern int const DEFAULT_RXC_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXC_POST1_TIME;
extern int const DEFAULT_RXC_POST2_TIME;
extern int const DEFAULT_RXC_WEEKS_BETWEEN;

extern int const DEFAULT_RXD_PREP1_TIME;
extern int const DEFAULT_RXD_PREP2_TIME;
extern int const DEFAULT_RXD_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXD_POST1_TIME;
extern int const DEFAULT_RXD_POST2_TIME;
extern int const DEFAULT_RXD_WEEKS_BETWEEN;

extern int const DEFAULT_RXE_PREP1_TIME;
extern int const DEFAULT_RXE_PREP2_TIME;
extern int const DEFAULT_RXE_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXE_POST1_TIME;
extern int const DEFAULT_RXE_POST2_TIME;
extern int const DEFAULT_RXE_WEEKS_BETWEEN;

extern int const DEFAULT_RXF_PREP1_TIME;
extern int const DEFAULT_RXF_PREP2_TIME;
extern int const DEFAULT_RXF_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXF_POST1_TIME;
extern int const DEFAULT_RXF_POST2_TIME;
extern int const DEFAULT_RXF_WEEKS_BETWEEN;

extern int const DEFAULT_RXG_PREP1_TIME;
extern int const DEFAULT_RXG_PREP2_TIME;
extern int const DEFAULT_RXG_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXG_POST1_TIME;
extern int const DEFAULT_RXG_POST2_TIME;
extern int const DEFAULT_RXG_WEEKS_BETWEEN;

extern int const DEFAULT_RXH_PREP1_TIME;
extern int const DEFAULT_RXH_PREP2_TIME;
extern int const DEFAULT_RXH_INFUSION_MAKE_TIME;
extern int const DEFAULT_RXH_POST1_TIME;
extern int const DEFAULT_RXH_POST2_TIME;
extern int const DEFAULT_RXH_WEEKS_BETWEEN;

//Default times for other injections
extern double const DEFAULT_INJECTION1_PREP1_TIME;
extern int const DEFAULT_INJECTION1_PREP2_TIME;
extern int const DEFAULT_INJECTION1_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION1_POST1_TIME;
extern int const DEFAULT_INJECTION1_POST2_TIME;
extern int const DEFAULT_INJECTION1_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION2_PREP1_TIME;
extern int const DEFAULT_INJECTION2_PREP2_TIME;
extern int const DEFAULT_INJECTION2_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION2_POST1_TIME;
extern int const DEFAULT_INJECTION2_POST2_TIME;
extern int const DEFAULT_INJECTION2_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION3_PREP1_TIME;
extern int const DEFAULT_INJECTION3_PREP2_TIME;
extern int const DEFAULT_INJECTION3_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION3_POST1_TIME;
extern int const DEFAULT_INJECTION3_POST2_TIME;
extern int const DEFAULT_INJECTION3_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION4_PREP1_TIME;
extern int const DEFAULT_INJECTION4_PREP2_TIME;
extern int const DEFAULT_INJECTION4_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION4_POST1_TIME;
extern int const DEFAULT_INJECTION4_POST2_TIME;
extern int const DEFAULT_INJECTION4_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION5_PREP1_TIME;
extern int const DEFAULT_INJECTION5_PREP2_TIME;
extern int const DEFAULT_INJECTION5_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION5_POST1_TIME;
extern int const DEFAULT_INJECTION5_POST2_TIME;
extern int const DEFAULT_INJECTION5_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION6_PREP1_TIME;
extern int const DEFAULT_INJECTION6_PREP2_TIME;
extern int const DEFAULT_INJECTION6_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION6_POST1_TIME;
extern int const DEFAULT_INJECTION6_POST2_TIME;
extern int const DEFAULT_INJECTION6_WEEKS_BETWEEN;

extern double const DEFAULT_INJECTION7_PREP1_TIME;
extern int const DEFAULT_INJECTION7_PREP2_TIME;
extern int const DEFAULT_INJECTION7_INFUSION_MAKE_TIME;
extern int const DEFAULT_INJECTION7_POST1_TIME;
extern int const DEFAULT_INJECTION7_POST2_TIME;
extern int const DEFAULT_INJECTION7_WEEKS_BETWEEN;

//Default times for simponi aria
extern int const DEFAULT_SIMPONI_ARIA_PREP1_TIME;
extern int const DEFAULT_SIMPONI_ARIA_PREP2_TIME;
extern int const DEFAULT_SIMPONI_ARIA_INFUSION_MAKE_TIME;
extern int const DEFAULT_SIMPONI_ARIA_POST1_TIME;
extern int const DEFAULT_SIMPONI_ARIA_POST2_TIME;

extern int const DEFAULT_STELARA_PREP1_TIME;
extern int const DEFAULT_STELARA_PREP2_TIME;
extern int const DEFAULT_STELARA_INFUSION_MAKE_TIME;
extern int const DEFAULT_STELARA_POST1_TIME;
extern int const DEFAULT_STELARA_POST2_TIME;

extern int const MAX_NUMBER_OF_CHAIRS;
extern int const MAX_NUMBER_OF_STAFF;

@interface Constants : NSObject

@end
