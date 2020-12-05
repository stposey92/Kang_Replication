	
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Ethiopia\2013_2014"
use "sect1_hh_w2_Head_ind..dta",clear
gen education=hh_s1q15 if hh_s1q02==5
replace education=hh_s1q19 if hh_s1q02==5
replace education=0 if hh_s1q15==98
replace education=6 if hh_s1q15==93
replace education=12 if hh_s1q15==94
replace education=1 if hh_s1q15==95
replace education=1 if hh_s1q15==96
replace education=0 if hh_s1q15==78
bysort household_id2: egen educations=max(education)
drop if hh_s1q02!=1
save "sect1_hh_w2_Head.dta",replace
*level data sets
use "Pub_ETH_HouseholdGeovars_Y2.dta",clear
merge 1:1 household_id2 using "sect1_hh_w2_Head"
drop if _merge!=3
drop _merge
gen age=hh_s1q04_a
*drop vars don't need
drop dist_popcenter-individual_id2 saq07 saq08 hh_s1q04c-hh_s1q04f hh_s1q05-hh_saq08
save "hh_level.dta",replace
*merge field level data
use "Pub_ETH_PlotGeovariables_Y2_field.dta",clear
gen parcel_id2=holder_id+"_"+parcel_id
merge m:1 parcel_id2 using "sect2_pp_w2_ownership_parcel.dta"
drop if _merge!=3
drop _merge
merge 1:1 field_id2 using "sect_3rca_pp_w2_Plotsize_field.dta"
drop if _merge!=3
drop _merge plot_srtmslp-plot_twi pp_s2q00-pp_s2q03b pp_s2q04-pp_s2q08 pp_s2q10-pp_rcq01 pp_rcq03_a-pp_rcq09
save "field_level.dta",replace
*Begin Plot level
use "sect3_pp_w2_Decisions_plot.dta",clear
merge 1:1 plot_id using "sect4_pp_w2_Crop_plot.dta"
drop if _merge!=3
drop _merge
merge 1:1 plot_id using "sect9_ph_w2_Output_plot.dta"
drop if _merge!=3
drop _merge
merge 1:1 plot_id using "sect10_ph_w2_labor_plot.dta"
drop if _merge!=3
drop _merge pp_saq07-pp_s3q01 pp_s3q03-pp_s3q05 pp_s3q06_a-pp_s3q09  pp_s3q11-pp_s3q14 pp_s3q30 pp_s3q33-plots pp_s4q00-pp_s4q04 pp_s4q08-ph_s9q03
drop ph_s9q05-ph_s9q07_b ph_s9q08-ph_s10q00c 
gen field_id2=holder_id+"_"+parcel_id+"_"+ field_id
save "plot_level.dta",replace
*Create a single dataset for w2
use "hh_level.dta",clear
merge 1:m household_id2 using "field_level.dta"
drop if _merge!=3
drop _merge
merge 1:m field_id2 using "plot_level.dta"
drop if _merge!=3
drop _merge
gen wave=2
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Data"
save "ETH_w2.dta",replace
*************************************************************************************
*											Begin W3								*
*************************************************************************************
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Ethiopia\2015_2016\Data"
use "sect1_hh_w3",clear
gen education=hh_s1q15 if hh_s1q02==5
replace education=hh_s1q19 if hh_s1q02==5
replace education=0 if hh_s1q15==98
replace education=6 if hh_s1q15==93
replace education=12 if hh_s1q15==94
replace education=1 if hh_s1q15==95
replace education=1 if hh_s1q15==96
replace education=0 if hh_s1q15==78
bysort household_id2: egen educations=max(education)
drop if hh_s1q02!=1

drop individual_id saq07 saq08 hh_s1q04c-hh_s1q04f hh_s1q05-obs
duplicates drop
save "sect1_hh_w3_head.dta",replace
use "HH_rd.dta",clear
merge 1:1 household_id2 using "sect1_hh_w3_Head"
drop if _merge!=3
drop _merge
save "hh_level3.dta",replace
*Begin Field level
*merge field level data
use "ETH_PlotGeovariables_Y3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen parcel_id2=holder_id+"_"+parcel_id
save "ETH_PlotGeovariables_Y3_field.dta",replace
use "sect2_pp_w3.dta",clear
tostring parcel_id,replace
gen parcel_id2=holder_id+"_"+parcel_id
save "sect2_pp_w3_field.dta",replace
use "sect_3rca_pp_w3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
save "sect_3rca_pp_w3_field",replace
*Merge
use "ETH_PlotGeovariables_Y3_field.dta",clear
merge m:1 parcel_id2 using "sect2_pp_w3_field.dta"
drop if _merge!=3
drop _merge
gen field_id2=parcel_id2+"_"+field_id
merge 1:1 field_id2 using "sect_3rca_pp_w3_field.dta"
drop if _merge!=3
drop _merge plot_srtmslp-plot_twi pp_s2q00-pp_s2q03b pp_s2q04-pp_s2q08 pp_s2q10-pp_rcq01 pp_rcq03_a-pp_rcq09
gen field_id2=parcel_id2+"_"+field_id
save "field_level3.dta",replace
*Begin Plot level
*create plot_id
use "sect3_pp_w3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
gen n=1
bysort field_id2: gen plots=sum(n)
tostring plots,replace
gen plot_id=field_id2+"_"+plots
save "sect3_pp_w3_plot.dta",replace
use "sect4_pp_w3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
gen n=1
bysort field_id2: gen plots=sum(n)
tostring plots,replace
gen plot_id=field_id2+"_"+plots
save "sect4_pp_w3_plot.dta",replace
use "sect9_ph_w3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
gen n=1
bysort field_id2: gen plots=sum(n)
tostring plots,replace
gen plot_id=field_id2+"_"+plots
save "sect9_ph_w3_plot.dta",replace
use "sect10_ph_w3.dta",clear
tostring parcel_id,replace
tostring field_id,replace
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
gen n=1
bysort field_id2: gen plots=sum(n)
tostring plots,replace
gen plot_id=field_id2+"_"+plots
save "sect10_ph_w3_plot.dta",replace
*Now Merge on plot_id
use "sect3_pp_w3_plot.dta",clear
merge 1:1 plot_id using "sect4_pp_w3_plot.dta"
drop if _merge!=3
drop _merge
merge 1:1 plot_id using "sect9_ph_w3_plot.dta"
drop if _merge!=3
drop _merge
merge 1:1 plot_id using "sect10_ph_w3_plot.dta"
drop if _merge!=3
drop _merge pp_saq07-pp_s3q01 pp_s3q03-pp_s3q05 pp_s3q06_a-pp_s3q09  pp_s3q11-pp_s3q14 pp_s3q30 pp_s3q33-plots pp_s4q00-pp_s4q04 pp_s4q08-ph_s9q03
drop ph_s9q05-ph_s9q07_b ph_s9q08-ph_s9q13
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
save "plot_level3.dta",replace
*Merge wave 3 dataset into 1 plot level
use "hh_level3.dta",clear
merge 1:m household_id2 using "field_level3.dta"
drop if _merge!=3
drop _merge
merge 1:m field_id2 using "plot_level3.dta"
drop if _merge!=3
drop _merge
gen wave=3
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Data"
save "ETH_w3.dta",replace
*************************************************************************************
*								MALAWI DATA											*
*************************************************************************************
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Malawi\2016\Data"
*start with 2016-2017
*Create HH level
use"HH_MOD_B.dta",clear
*Bring down to sex of Head of House
gen age=hh_b05a
drop if hh_b04!=1
drop hh_b04a-hh_b28
duplicates drop
rename hh_b03 Head_sex
drop hh_b04
merge 1:1 HHID using "HouseholdGeovariablesIHS4.dta"
drop if _merge!=3
drop _merge dist_popcenter-h2016_wetQstart lat_modified lon_modified
save "MA_hh_level2.dta",replace
*****************************************************
*****************************************************
*Create plot_level data
*begin by making unique id at the plot level
use "AG_MOD_C_plotsize.dta",clear
gen gardenid2 = substr(gardenid, 4, 4)
gen plotid2 = substr(plotid, 3, 3)
drop gardenid plotid
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen field_id=HHID+"_"+gardenid2
drop ag_c05e-ag_c07
save "AG_MOD_C.dta",replace
*****************************************************
*****************************************************
use "AG_MOD_D_inputs.dta",clear
gen gardenid2 = substr(gardenid, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen plotid2 = substr(plotid, 3, 3)
replace plotid2="0" if plotid2==" "
drop gardenid plotid
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen field_id=HHID+"_"+gardenid2
gen planting_d=(ag_d01==1)
replace planting_d=2 if ag_d01==2
replace planting_d=3 if ag_d01==1 & ag_d01_1==2
replace planting_d=3 if ag_d01==2 & ag_d01_1==2
replace planting_d=4 if planting_d==0
gen inorg_fertquantrs=ag_d39d+ag_d39j
gen Household_labor1rs=ag_d43b1*ag_d43c1
gen Household_labor2rs=ag_d43b2*ag_d43c2
gen Household_labor3rs=ag_d43b3*ag_d43c3
gen Household_labor4rs=ag_d43b4*ag_d43c4
gen Household_labor5rs=ag_d43b5*ag_d43c5
gen Household_labor6rs=ag_d43b6*ag_d43c6
gen Household_labor7rs=ag_d43b7*ag_d43c7
gen Household_labor8rs=ag_d43b8*ag_d43c8
gen Household_labor9rs=ag_d43b9*ag_d43c9
gen Household_labor10rs=ag_d43b10*ag_d43c10
gen Household_labor11rs=ag_d43b11*ag_d43c11
gen Household_labor12rs=ag_d43b12*ag_d43c12

replace Household_labor1rs=ag_d44b1*ag_d44c1
replace Household_labor2rs=ag_d44b2*ag_d44c2
replace Household_labor3rs=ag_d44b3*ag_d44c3
replace Household_labor4rs=ag_d44b4*ag_d44c4
replace Household_labor5rs=ag_d44b5*ag_d44c5
replace Household_labor6rs=ag_d44b6*ag_d44c6
replace Household_labor7rs=ag_d44b7*ag_d44c7
replace Household_labor8rs=ag_d44b8*ag_d44c8
replace Household_labor9rs=ag_d44b9*ag_d44c9
replace Household_labor10rs=ag_d44b10*ag_d44c10
replace Household_labor11rs=ag_d44b11*ag_d44c11
replace Household_labor12rs=ag_d44b12*ag_d44c12

replace Household_labor1rs=ag_d42b1*ag_d42c1
replace Household_labor2rs=ag_d42b2*ag_d42c2
replace Household_labor3rs=ag_d42b3*ag_d42c3
replace Household_labor4rs=ag_d42b4*ag_d42c4
replace Household_labor5rs=ag_d42b5*ag_d42c5
replace Household_labor6rs=ag_d42b6*ag_d42c6
replace Household_labor7rs=ag_d42b7*ag_d42c7
replace Household_labor8rs=ag_d42b8*ag_d42c8
replace Household_labor9rs=ag_d42b9*ag_d42c9
replace Household_labor10rs=ag_d42b10*ag_d42c10
replace Household_labor11rs=ag_d42b11*ag_d42c11
replace Household_labor12rs=ag_d42b12*ag_d42c12

replace Household_labor1rs=0 if Household_labor1rs==.
replace Household_labor2rs=0 if Household_labor2rs==.
replace Household_labor3rs=0 if Household_labor3rs==.
replace Household_labor4rs=0 if Household_labor4rs==.
replace Household_labor5rs=0 if Household_labor5rs==.
replace Household_labor6rs=0 if Household_labor6rs==.
replace Household_labor7rs=0 if Household_labor7rs==.
replace Household_labor8rs=0 if Household_labor8rs==.
replace Household_labor9rs=0 if Household_labor9rs==.
replace Household_labor10rs=0 if Household_labor10rs==.
replace Household_labor11rs=0 if Household_labor11rs==.
replace Household_labor12rs=0 if Household_labor12rs==.

gen hired_menrs=ag_d46a1+ag_d47a1+ag_d48a1
gen hired_womenrs=ag_d46a2+ag_d47a2+ag_d48a2
gen hired_childrenrs=ag_d46a3+ag_d47a3+ag_d48a3
gen avg_menwage=(ag_d46b1+ag_d47b1+ag_d48b1)/3
gen avg_womenwage=(ag_d46b2+ag_d47b2+ag_d48b2)/3
gen avg_childwage=(ag_d46b3+ag_d47b3+ag_d48b3)/3
drop ag_d21-ag_d35_1b ag_d39_1-ag_d39c_oth ag_d39e ag_d39f ag_d39h-ag_d39i_oth ag_d41_2-ag_d41c_oth 
drop  ag_d39d-ag_d39g_oth ag_d39j-ag_d70_oth
duplicates drop
save "AG_MOD_D.dta",replace
*****************************************************
*****************************************************
use "AG_MOD_I_income.dta",clear
drop ag_i05a ag_i05b ag_i07a-ag_i42_oth
gen income_own=(ag_i06a==1)
replace income_own=2 if ag_i06a==2 & ag_i06a!=1
replace income_own=3 if ag_i06a==1 & ag_i06b==2
replace income_own=3 if ag_i06a==2 & ag_i06b==1
replace income_own=4 if income_own==0
drop ag_i06a-ag_i06c
duplicates drop
*crop level
save "AG_MOD_I.dta",replace
*****************************************************
*****************************************************
use "AG_MOD_I2_landOwner.dta",clear
drop ag_i203_2 ag_i202-ag_i204_5 ag_i204_7-ag_i212_oth ag_i214-ag_i217b
gen gardenid2 = substr(gardenid, 4, 4)
drop gardenid 
replace gardenid2="0" if gardenid2==" "
gen field_id=HHID+"_"+gardenid2
gen plot_manager=(ag_i213_1a==1)
replace plot_manager=2 if ag_i213_1a==2
replace plot_manager=3 if ag_i213_1a==2 & ag_i213_1b==1
replace plot_manager=3 if ag_i213_1a==1 & ag_i213_1b==2
replace plot_manager=4 if plot_manager==0
drop ag_i204a_1-ag_i213_1b
duplicates drop
save "AG_MOD_I2.dta",replace
use "AG_MOD_B2_ownership.dta",clear
gen gardenid2 = substr(gardenid, 4, 4)
drop gardenid 
replace gardenid2="0" if gardenid2==" "
gen field_id=HHID+"_"+gardenid2
gen plot_manager=(ag_b204a__0==1)
replace plot_manager=2 if ag_b204a__0==2
replace plot_manager=3 if ag_b204a__0==2 & ag_b204a__1==1
replace plot_manager=3 if ag_b204a__0==1 & ag_b204a__1==2
replace plot_manager=4 if plot_manager==0
drop ag_b202-ag_b217b
save "AG_MOD_B2.dta",replace
merge 1:1 field_id using "AG_MOD_I2.dta"
drop _merge
save "MA_fieldlvl2.dta",replace
*****************************************************
*****************************************************
use "AG_MOD_K_DM.dta",clear
gen gardenid2 = substr(gardenid, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen plotid2 = substr(plotid, 3, 3)
replace plotid2="0" if plotid2==" "
drop gardenid plotid
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen field_id=HHID+"_"+gardenid2
replace ag_k21a=0 if ag_k21a==.
replace ag_k37=2 if ag_k37==.
gen crop=ag_k21a
tostring crop,replace
gen cereal=(ag_k21a==1)
replace cereal=1 if ag_k21b==1
replace cereal=1 if ag_k21c==1
replace cereal=1 if ag_k21d==1
replace cereal=1 if ag_k21e==1
replace cereal=1 if ag_k21_oth=="MAIZE"
drop ag_k21a-ag_k21_oth
gen planting_d=(ag_k02==1)
replace planting_d=2 if ag_k02==2
replace planting_d=3 if ag_k02==1 & ag_k02_1==2
replace planting_d=3 if ag_k02==2 & ag_k02_1==2
replace planting_d=4 if planting_d==0
gen inorg_fertquantds=ag_k40d+ag_k40i
drop ag_k01-ag_k03 ag_k22-ag_k36_1b ag_k40-ag_k40_2 ag_k39-ag_k40i 
gen Household_labor1ds=ag_k43b1*ag_k43c1
gen Household_labor2ds=ag_k43b2*ag_k43c2
gen Household_labor3ds=ag_k43b3*ag_k43c3
gen Household_labor4ds=ag_k43b4*ag_k43c4
gen Household_labor5ds=ag_k43b5*ag_k43c5
gen Household_labor6ds=ag_k43b6*ag_k43c6
gen Household_labor7ds=ag_k43b7*ag_k43c7

replace Household_labor1ds=ag_k44b1*ag_k44c1
replace Household_labor2ds=ag_k44b2*ag_k44c2
replace Household_labor3ds=ag_k44b3*ag_k44c3
replace Household_labor4ds=ag_k44b4*ag_k44c4
replace Household_labor5ds=ag_k44b5*ag_k44c5
replace Household_labor6ds=ag_k44b6*ag_k44c6
replace Household_labor7ds=ag_k44b7*ag_k44c7

replace Household_labor1ds=ag_k45b1*ag_k45c1
replace Household_labor2ds=ag_k45b2*ag_k45c2
replace Household_labor3ds=ag_k45b3*ag_k45c3
replace Household_labor4ds=ag_k45b4*ag_k45c4
replace Household_labor5ds=ag_k45b5*ag_k45c5
replace Household_labor6ds=ag_k45b6*ag_k45c6
replace Household_labor7ds=ag_k45b7*ag_k45c7

replace Household_labor1ds=0 if Household_labor1ds==.
replace Household_labor2ds=0 if Household_labor2ds==.
replace Household_labor3ds=0 if Household_labor3ds==.
replace Household_labor4ds=0 if Household_labor4ds==.
replace Household_labor5ds=0 if Household_labor5ds==.
replace Household_labor6ds=0 if Household_labor6ds==.
replace Household_labor7ds=0 if Household_labor7ds==.


gen hired_mends=ag_k46a1+ag_k47a
gen hired_womends=ag_k46a2+ag_k47b
gen hired_childds=ag_k46a3+ag_k47c
gen avg_menwageds=ag_k46b1
gen avg_womenwageds=ag_k46b2
gen avg_childwageds=ag_k46b3

drop ag_k43a1-true_plot_all ag_k41-ag_k42g_oth  ag_k38b ag_k38b_oth ag_k38a
duplicates drop
*Bring it up to plot level
gen n=1
bysort plot_id: egen plots=sum(n)
bysort plot_id: egen menwage_ds=sum(avg_menwageds)
bysort plot_id: egen womenwage_ds=sum(avg_womenwageds)
bysort plot_id: egen childwage_ds=sum(avg_childwageds)
replace menwage_ds=menwage_ds/plots
replace womenwage_ds=womenwage_ds/plots
replace childwage_ds=childwage_ds/plots

bysort plot_id: egen hh_lab1ds=sum(Household_labor1ds)
bysort plot_id: egen hh_lab2ds=sum(Household_labor2ds)
bysort plot_id: egen hh_lab3ds=sum(Household_labor3ds)
bysort plot_id: egen hh_lab4ds=sum(Household_labor4ds)
bysort plot_id: egen hh_lab5ds=sum(Household_labor5ds)
bysort plot_id: egen hh_lab6ds=sum(Household_labor6ds)
bysort plot_id: egen hh_lab7ds=sum(Household_labor7ds)
bysort plot_id: egen hired_men_ds=sum(hired_mends)
bysort plot_id: egen hired_women_ds=sum(hired_womends)
bysort plot_id: egen hired_child_ds=sum(hired_childds)
bysort plot_id: egen infert_ds=sum(inorg_fertquantds)
bysort plot_id: egen cereals=max(cereal)
*organic yes and no within plot (if it uses org at all choose yes)
bysort plot_id: egen org_fert=min(ag_k37)
drop ag_k37 cereal crop
*plot manager changes within plot, change to joint if both 1 and 2 are on it, else 1 or 2
*only joint managed when plots=2
replace planting_d=3 if plots>=2
drop inorg_fertquantds-hired_childds avg_menwageds-avg_childwageds plots
duplicates drop
bysort plot_id: egen plots=sum(n)
save "AG_MOD_K.dta",replace
*****************************************************
*****************************************************
use "AG_MOD_G_outputs.dta",clear
gen gardenid2 = substr(gardenid, 4, 4)
gen plotid2 = substr(plotid, 3, 3)
drop gardenid plotid
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
drop ag_g0a-ag_g13c
gen output_d=(ag_g14a==1)
replace output_d=2 if ag_g14a==2
replace output_d=3 if ag_g14a==1 & ag_g14b==2
replace output_d=3 if ag_g14a==2 & ag_g14b==1
replace output_d=4 if output_d==0
drop crop_code-ag_g14b 
duplicates drop
gen n=1

bysort plot_id: egen plots=sum(n)
bysort plot_id: egen outputs=max(output_d)
drop output_d
duplicates drop
save "AG_MOD_G.dta",replace
*****************************************************
*****************************************************


*****************************************************
*****************************************************
*plot level, A lot were not sampled in AG_MOD_K
use "AG_MOD_K.dta",clear
merge 1:1 plot_id using "AG_MOD_D.dta"
drop _merge
merge 1:1 plot_id using "AG_MOD_G.dta"
drop if _merge!=3
drop _merge
merge 1:1 plot_id using "AG_MOD_C.dta"
drop if _merge!=3
drop _merge
save "MA_plotlvl2.dta",replace
*****************************************************
*****************************************************
use "MA_hh_level2.dta",clear
merge 1:m HHID using "MA_fieldlvl2.dta"
drop if _merge!=3
drop _merge
merge 1:m field_id using "MA_plotlvl2.dta"
drop if _merge!=3
drop _merge
replace org_fert=1 if ag_d36==1
drop ag_d01-ag_d20_oth plots ag_d36

gen hh_lab_1=hh_lab1ds+ Household_labor1rs
gen hh_lab_2=hh_lab1ds+ Household_labor2rs
gen hh_lab_3=hh_lab1ds+ Household_labor3rs
gen hh_lab_4=hh_lab1ds+ Household_labor4rs
gen hh_lab_5=hh_lab1ds+ Household_labor5rs
gen hh_lab_6=hh_lab1ds+ Household_labor6rs
gen hh_lab_7=hh_lab1ds+ Household_labor7rs
gen men_wage=(menwage_ds+avg_menwage)/2
gen women_wage=(womenwage_ds+avg_womenwage)/2
gen child_wage=(childwage_ds+avg_childwage)/2
gen hired_men=hired_menrs+hired_men_ds
gen hired_women=hired_womenrs+hired_women_ds
gen hired_child=hired_childrenrs+hired_child_ds

drop Household_labor1rs-avg_childwage n-hired_child_ds
gen wave=2
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Data"
save "Malawi_w2.dta",replace
*****************************************************
*					2013							*
*****************************************************
*begin organizing data and cleaning
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Malawi\2013\MWI_2010-2013_IHPS_v01_M_Stata\Data"
use "AG_MOD_C_13_plotsize.dta",clear
rename y2_hhid HHID
gen gardenid2 = substr(ag_c03_2, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen plotid2 = substr(ag_c00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen garden_id=HHID+"_"+gardenid2
drop ag_c03_2 ag_c00
replace ag_c04a=ag_c04a*2.47105 if ag_c04b==2
replace ag_c04a=ag_c04a*0.000247105 if ag_c04b==3
gen plot_size=ag_c04a
drop qx_type-ag_c07
save "AG_MOD_C_13.dta",replace
*garden plot level
*****************************************************
*****************************************************
use "AG_MOD_D_13_planting.dta",clear
rename y2_hhid HHID
gen plotid2 = substr(ag_d00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
drop  ag_d00
gen org_fert=ag_d36
gen plant_d=(ag_d01==1)
replace plant_d=2 if ag_d01==2
replace plant_d=3 if ag_d01==2 & ag_d01_1==1
replace plant_d=3 if ag_d01==1 & ag_d01_1==2
replace plant_d=4 if plant_d==0
gen inorg_fert=ag_d39d
*begin household labor
gen hh_lab1=ag_d42b*ag_d42c
gen hh_lab2=ag_d42f*ag_d42g
gen hh_lab3=ag_d42j*ag_d42k
gen hh_lab4=ag_d42n*ag_d42o
gen hh_lab5=ag_d43b*ag_d43c
gen hh_lab6=ag_d43f*ag_d43g
gen hh_lab7=ag_d43j*ag_d43k
gen hh_lab8=ag_d43n*ag_d43o
gen hh_lab9=ag_d44b*ag_d44c
gen hh_lab10=ag_d44f*ag_d44g
gen hh_lab11=ag_d44j*ag_d44k
gen hh_lab12=ag_d44n*ag_d44o
replace hh_lab1=0 if hh_lab1==.
replace hh_lab2=0 if hh_lab2==.
replace hh_lab3=0 if hh_lab3==.
replace hh_lab4=0 if hh_lab4==.
replace hh_lab5=0 if hh_lab5==.
replace hh_lab6=0 if hh_lab6==.
replace hh_lab7=0 if hh_lab7==.
replace hh_lab8=0 if hh_lab8==.
replace hh_lab9=0 if hh_lab9==.
replace hh_lab10=0 if hh_lab10==.
replace hh_lab11=0 if hh_lab11==.
replace hh_lab12=0 if hh_lab12==.
gen hired_men=ag_d47a
gen hired_women=ag_d47c
gen hired_child=ag_d47e
gen men_wage=ag_d47b
gen women_wage=ag_d47d
gen child_wage=ag_d47f
drop qx_type-ag_d68
save "AG_MOD_D_13.dta",replace
*hhid_plot level
*****************************************************
*****************************************************
use "AG_MOD_G_13_outputs.dta",clear
rename y2_hhid HHID
gen plotid2 = substr(ag_g00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
drop qx_type-ag_g0a ag_g0e-ag_g12b ag_g00
gen cereal=(ag_g0b==1)
replace cereal=1 if ag_g0b==2
replace cereal=1 if ag_g0b==3
replace cereal=1 if ag_g0b==4
replace cereal=1 if ag_g0b==15
replace cereal=1 if ag_g0b==16
replace cereal=1 if ag_g0b==17
replace cereal=1 if ag_g0b==18
replace cereal=1 if ag_g0b==19
replace cereal=1 if ag_g0b==20
replace cereal=1 if ag_g0b==21
replace cereal=1 if ag_g0b==22
replace cereal=1 if ag_g0b==23
drop ag_g0b 
gen output_d=(ag_g14a==1)
replace output_d=2 if ag_g14a==2
replace output_d=3 if ag_g14a==2 & ag_g14b==1
replace output_d=3 if ag_g14a==1 & ag_g14b==2
replace output_d=4 if output_d==0 
drop ag_g14a ag_g14b
bysort plotid1: egen cereals=max(cereal)
drop cereal
bysort plotid1: egen outputs=max(output_d)
replace output_d=3 if outputs==3
replace output_d=4 if outputs==4
replace output_d=3 if output_d==1 & outputs==2
drop outputs
bysort plotid1: egen outputs=max(output_d)
replace output_d=3 if outputs==3
replace output_d=4 if outputs==4
replace output_d=3 if output_d==1 & outputs==2
drop outputs occ
duplicates drop
save "AG_MOD_G_13.dta",replace
*HHID_plot level
*****************************************************
*****************************************************
use "AG_MOD_K_13_planting.dta",clear
rename y2_hhid HHID
gen plotid2 = substr(ag_k00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
gen plant_d=(ag_k02==1)
replace plant_d=2 if ag_k02==2
replace plant_d=3 if ag_k02==2 & ag_k02_1==1
replace plant_d=3 if ag_k02==1 & ag_k02_1==2
replace plant_d=4 if plant_d==0
gen plot_own=(ag_k05a==1)
replace plot_own=2 if ag_k05a==2
replace plot_own=3 if ag_k05a==2 & ag_k05b==1
replace plot_own=3 if ag_k05a==1 & ag_k05b==2
replace plot_own=4 if plot_own==0
gen org_fert=(ag_k37)
gen inorg_fert=ag_k40d
*start with labor
gen hh_lab1k=ag_k43b*ag_k43c
gen hh_lab2k=ag_k43f*ag_k43g
gen hh_lab3k=ag_k43j*ag_k43k
gen hh_lab4k=ag_k43n*ag_k43o
gen hh_lab5k=ag_k44b*ag_k44c
gen hh_lab6k=ag_k44f*ag_k44g
gen hh_lab7k=ag_k44j*ag_k44k
gen hh_lab8k=ag_k44n*ag_k44o
gen hh_lab9k=ag_k45b*ag_k45c
gen hh_lab10k=ag_k45f*ag_k45g
gen hh_lab11k=ag_k45j*ag_k45k
gen hh_lab12k=ag_k45n*ag_k45o
replace hh_lab1k=0 if hh_lab1k==.
replace hh_lab2k=0 if hh_lab2k==.
replace hh_lab3k=0 if hh_lab3k==.
replace hh_lab4k=0 if hh_lab4k==.
replace hh_lab5k=0 if hh_lab5k==.
replace hh_lab6k=0 if hh_lab6k==.
replace hh_lab7k=0 if hh_lab7k==.
replace hh_lab8k=0 if hh_lab8k==.
replace hh_lab9k=0 if hh_lab9k==.
replace hh_lab10k=0 if hh_lab10k==.
replace hh_lab11k=0 if hh_lab11k==.
replace hh_lab12k=0 if hh_lab12k==.

gen hired_menk=ag_k46a
gen hired_womenk=ag_k46c
gen hired_chilk=ag_k46e
gen men_wagek=ag_k46b
gen women_wagek=ag_k46d
gen child_wagek=ag_k46f
drop qx_type-ag_k48c
save "AG_MOD_K_13.dta",replace
*HH_plot level
*****************************************************
*****************************************************
use "AG_MOD_I1_13_gardensize.dta",clear
rename y2_hhid HHID
gen gardenid2 = substr(ag_i100a, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen garden_id=HHID+"_"+gardenid2
gen garden_size=ag_i105a
replace garden_size=ag_i105a*0.000247105 if ag_i105b==2
drop qx_type-gardenid2
save "AG_MOD_I1_13.dta",replace
*garden level
*****************************************************
*****************************************************
use "AG_MOD_O1_13_gardensize.dta",clear
rename y2_hhid HHID
gen gardenid2 = substr(ag_o100a, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen garden_id=HHID+"_"+gardenid2
replace ag_o104a=ag_o104a*2.47105 if ag_o104b==2
replace ag_o104a=ag_o104a*0.000247105 if ag_o104b==3
gen garden_size=ag_o104a
drop qx_type-gardenid2
save "AG_MOD_O1_13.dta",replace
*garden level
*****************************************************
*****************************************************
use "AG_MOD_J_13_plotsize.dta",clear
rename y2_hhid HHID
gen gardenid2 = substr(ag_j04_2, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen plotid2 = substr(ag_j00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen garden_id=HHID+"_"+gardenid2
gen plot_size=ag_j05a
replace plot_size=ag_j05a*0.000247105 if ag_j05b==2
drop qx_typ-plotid2
save "AG_MOD_J_13.dta",replace
*garden_plot lvel
*****************************************************
*****************************************************
use "AG_MOD_O2_13_plotsize.dta",clear
rename y2_hhid HHID
gen gardenid2 = substr(ag_o03_2, 4, 4)
replace gardenid2="0" if gardenid2==" "
gen plotid2 = substr(ag_o00, 3, 3)
replace plotid2="0" if plotid2==" "
gen plotid1=HHID+"_"+plotid2
gen plot_id=HHID+"_"+gardenid2+"_"+plotid2
gen garden_id=HHID+"_"+gardenid2
replace ag_o04a=ag_o04a*2.47105 if ag_o04b==2
replace ag_o04a=ag_o04a*0.000247105 if ag_o04b==3
gen plot_size=ag_o04a
drop qx_typ-plotid2
save "AG_MOD_O2_13.dta",replace
*garden_plotlevel
*****************************************************
*****************************************************
*create garden_plot level data
use "AG_MOD_C_13.dta",clear
merge 1:1 plot_id using "AG_MOD_J_13.dta"
drop _merge
merge 1:1 plot_id using "AG_MOD_O2_13.dta"
drop _merge
save "MA_GP_13.dta",replace
use "AG_MOD_O1_13.dta",clear
merge 1:m garden_id using "MA_GP_13.dta"
drop if _merge!=3 
drop _merge
save "MA_HGP_13.dta",replace
*****************************************************
*****************************************************
*create HHID_plot level data
use "AG_MOD_D_13.dta",clear
merge 1:1 plotid1 using "AG_MOD_K_13.dta"
drop _merge
merge 1:1 plotid1 using "AG_MOD_G_13.dta"
drop _merge
drop if output_d==.
drop if plot_own==.
drop if plant_d==.
gen hh_lab1t=hh_lab1+hh_lab1k
gen hh_lab2t=hh_lab2+hh_lab2k
gen hh_lab3t=hh_lab3+hh_lab3k
gen hh_lab4t=hh_lab4+hh_lab4k
gen hh_lab5t=hh_lab5+hh_lab5k
gen hh_lab6t=hh_lab6+hh_lab6k
gen hh_lab7t=hh_lab7+hh_lab7k
gen hh_lab8t=hh_lab8+hh_lab8k
gen hh_lab9t=hh_lab9+hh_lab9k
gen hh_lab10t=hh_lab10+hh_lab10k
gen hh_lab11t=hh_lab11+hh_lab11k
gen hh_lab12t=hh_lab12+hh_lab12k

gen hired_ment=hired_men+hired_menk
gen hired_woment=hired_women+hired_womenk
gen hired_childt=hired_child+hired_chilk

gen men_waget=(men_wage+men_wagek)/2
gen women_waget=(women_wage+women_wagek)/2
gen child_waget=(child_wage+child_wagek)/2
drop hh_lab1-child_wage hh_lab1k-child_wagek



save "MA_HP_13.dta",replace
*****************************************************
*****************************************************
*create HHID level data
use "HH_MOD_B_13_head.dta",clear
drop if hh_b04!=1
gen hh_sex=hh_b03
gen age=hh_b05a
gen education=hh_b22_3
rename y2_hhid HHID
drop occ PID-hh_b28
duplicates drop
save "HH_MOD_B_13.dta",replace
use "HouseholdGeovariables_IHPS_13.dta",clear
rename y2_hhid HHID
drop dist_popcenter-distY1Y2
duplicates drop
save "HHGeo.dta",replace
merge 1:1 HHID using "HH_MOD_B_13.dta"
drop if _merge!=3
drop _merge
save "MA_HH_13.dta",replace
*****************************************************
*****************************************************
*combine wave 1
use "MA_HP_13.dta",clear
merge 1:m plotid1 using "MA_GP_13.dta"
drop if _merge!=3
drop _merge
merge m:1 HHID using "MA_HH_13.dta"
drop if _merge!=3
drop _merge
gen wave=1
cd "C:\Users\19047\Google Drive\PhD\Classes\Ag and App Econ Topic\Replication\Data"
save "MA_13.dta",replace
*****************************************************
*****************************************************
*combine both waves
use "Malawi_w2.dta",clear
drop ag_d37a-ag_d38 
drop if ag_c04b_oth!=""
replace ag_c04a=ag_c04a if ag_c04a==2
replace ag_c04a=ag_c04a*0.000247105 if ag_c04a==3
gen plot_size=ag_c04a
drop ag_c04a-ag_c04c
merge 1:1 plot_id using "MA_13.dta"
gen country=2
drop occ
replace plant_d=planting_d if plant_d==.
drop planting
replace output_d=outputs if output_d==.
drop outputs

replace plot_own=plot_manager if plot_own==.
drop plot_manager

replace hh_lab1t=0 if hh_lab1t==.
replace hh_lab2t=0 if hh_lab2t==.
replace hh_lab3t=0 if hh_lab3t==.
replace hh_lab4t=0 if hh_lab4t==.
replace hh_lab5t=0 if hh_lab5t==.
replace hh_lab6t=0 if hh_lab6t==.
replace hh_lab7t=0 if hh_lab7t==.
replace hh_lab8t=0 if hh_lab8t==.
replace hh_lab9t=0 if hh_lab9t==.
replace hh_lab10t=0 if hh_lab10t==.
replace hh_lab11t=0 if hh_lab11t==.
replace hh_lab12t=0 if hh_lab12t==.

rename hh_lab8t tot_lab8
rename hh_lab9t tot_lab9
rename hh_lab10t tot_lab10
rename hh_lab11t tot_lab11
rename hh_lab12t tot_lab12


replace hh_lab_1=0 if hh_lab_1==.
replace hh_lab_2=0 if hh_lab_2==.
replace hh_lab_3=0 if hh_lab_3==.
replace hh_lab_4=0 if hh_lab_4==.
replace hh_lab_5=0 if hh_lab_5==.
replace hh_lab_6=0 if hh_lab_6==.
replace hh_lab_7=0 if hh_lab_7==.

gen tot_lab1=hh_lab1t+hh_lab_1
gen tot_lab2=hh_lab2t+hh_lab_2
gen tot_lab3=hh_lab3t+hh_lab_3
gen tot_lab4=hh_lab4t+hh_lab_4
gen tot_lab5=hh_lab5t+hh_lab_5
gen tot_lab6=hh_lab6t+hh_lab_6
gen tot_lab7=hh_lab7t+hh_lab_7
drop hh_lab_1-hh_lab_7
drop hh_lab1t-hh_lab7t
replace hired_men=0 if hired_men==.
replace hired_ment=0 if hired_ment==.
replace hired_women=0 if hired_women==.
replace hired_woment=0 if hired_woment==.
replace hired_child=0 if hired_child==.
replace hired_childt=0 if hired_childt==.
gen tot_hired_men=hired_men+hired_ment
gen tot_hired_women=hired_women+hired_woment
gen tot_hired_child=hired_child+hired_childt
gen avg_wagemen=(men_wage+men_waget)/2
gen avg_wagewomen=(women_wage+women_waget)/2
gen avg_wagechild=(child_wage+child_waget)/2
drop hired_men-hired_child hired_ment-hired_childt men_wage-child_wage men_waget-child_waget _merge

save "MA.dta",replace
*****************************************************
*****************************************************
use "ETH_w2.dta",clear
gen r = saq01
tostring r,replace
tostring saq02, replace
tostring saq03, replace
gen unit=pp_s3q02_c
tostring unit, replace
gen uid=r+"_"+saq02+"_"+saq03+"_"+unit
merge m:1 uid using "ET_local_area_unit_conversion_13.dta"
drop if pp_s3q02_c==8
*create plot size and convert to sqmeters. Not all of the conversions made it
destring unit,replace
gen plot_size=pp_s3q02_a
replace plot_size=plot_size*2.47105 if unit==1
gen acres=(unit==1)
replace acres=1 if unit==3
replace acres=1 if unit==4
replace acres=1 if unit==5
replace acres=1 if unit==6
replace acres=1 if unit==7
replace acres=1 if region==3 & unit==4
replace acres=1 if region==4 & unit==4
replace acres=1 if region==8 & unit==4
replace acres=1 if region==3 & unit==5
replace acres=1 if region==3 & unit==6
replace acres=1 if region==5 & unit==4
*To get as many obs as possible average across all of the regions
replace plot_size=plot_size*1609.978*0.000247105 if unit==3
replace plot_size=plot_size*291.4066*0.000247105 if unit==4
replace plot_size=plot_size*1197.805*0.000247105 if unit==5
replace plot_size=plot_size*1986.144*0.000247105 if unit==6
replace plot_size=plot_size*1609.978*0.000247105 if unit==7
*now take average by region
replace plot_size=plot_size*1947.582*0.000247105 if region==1 & unit==3
replace plot_size=plot_size*1941.238*0.000247105 if region==2 & unit==3
replace plot_size=plot_size*1472.163*0.000247105 if region==3 & unit==3
replace plot_size=plot_size*991.1986*0.000247105 if region==4 & unit==3
replace plot_size=plot_size*1476.523*0.000247105 if region==5 & unit==3
replace plot_size=plot_size*1205.46*0.000247105 if region==6 & unit==3
replace plot_size=plot_size*1042.535*0.000247105 if region==7 & unit==3
replace plot_size=plot_size*570*0.000247105 if region==8 & unit==3
replace plot_size=plot_size*1051.083*0.000247105 if region==9 & unit==3

replace plot_size=plot_size*304.4126*0.000247105 if region==3 & unit==4
replace plot_size=plot_size*172.02*0.000247105 if region==4 & unit==4
replace plot_size=plot_size*140*0.000247105 if region==8 & unit==4

replace plot_size=plot_size*1197.805*0.000247105 if region==3 & unit==5
replace plot_size=plot_size*2113.16*0.000247105 if region==3 & unit==6
replace plot_size=plot_size*843*0.000247105 if region==5 & unit==6
replace plot_size=plot_size*conversion*0.000247105 if _merge==3 // acres

drop ea_id-coord_desc _merge
gen hh_sex=hh_s1q03
gen cereals=(crop_code==1)
replace cereals=1 if crop_code==2
replace cereals=1 if crop_code==3
replace cereals=1 if crop_code==4
replace cereals=1 if crop_code==5
replace cereals=1 if crop_code==6
replace cereals=1 if crop_code==7
replace cereals=1 if crop_code==8
gen plot_own=(pp_s2q03c_a==1)
replace plot_own=2 if pp_s2q03c_a==2
replace plot_own=3 if pp_s2q03c_a==2 &pp_s2q03c_b==1
replace plot_own=3 if pp_s2q03c_a==1 &pp_s2q03c_b==2
replace plot_own=4 if plot_own==0
gen plot_manager=(pp_s2q08a_a==1)
replace plot_manager=2 if pp_s2q08a_a==2
replace plot_manager=3 if pp_s2q08a_a==2 &pp_s2q08a_b==1
replace plot_manager=3 if pp_s2q08a_a==1 &pp_s2q08a_b==2
replace plot_manager=4 if plot_manager==0
gen plant_d=(pp_s3q10a==1)
replace plant_d=2 if pp_s3q10a==2
replace plant_d=3 if pp_s3q10a==2 &pp_s3q10b==1
replace plant_d=3 if pp_s3q10a==1 &pp_s3q10b==2
replace plant_d=4 if plant_d==0
gen output_d=(ph_s9q07a_1==1)
replace output_d=2 if ph_s9q07a_1==2
replace output_d=3 if ph_s9q07a_1==2 &ph_s9q07a_2==1
replace output_d=3 if ph_s9q07a_1==1 &ph_s9q07a_2==2
replace output_d=4 if output_d==0
*fert
replace pp_s3q16_a=0 if pp_s3q16_a==.
replace pp_s3q19_a=0 if pp_s3q19_a==.
gen inorg_fert=pp_s3q16_a+pp_s3q19_a
gen org_fert=(pp_s3q25==1)

gen hh_lab1=pp_s3q27_b*pp_s3q27_c
gen hh_lab2=pp_s3q27_f*pp_s3q27_g
gen hh_lab3=pp_s3q27_j*pp_s3q27_k
gen hh_lab4=pp_s3q27_n*pp_s3q27_o
gen hh_lab5=pp_s3q27_r*pp_s3q27_s
gen hh_lab6=pp_s3q27_v*pp_s3q27_w
gen hh_lab7=pp_s3q27_z*pp_s3q27_ca
replace hh_lab1=0 if hh_lab1==.
replace hh_lab2=0 if hh_lab2==.
replace hh_lab3=0 if hh_lab3==.
replace hh_lab4=0 if hh_lab4==.
replace hh_lab5=0 if hh_lab5==.
replace hh_lab6=0 if hh_lab6==.
replace hh_lab7=0 if hh_lab7==.
gen hh_menl=pp_s3q29_b
gen hh_womenl=pp_s3q29_d
gen hh_childl=pp_s3q29_f
gen hired_men=pp_s3q28_b
gen hired_women=pp_s3q28_e
gen hired_child=pp_s3q28_h
replace hired_men=0 if hired_men==.
replace hired_women=0 if hired_women==.
replace hired_child=0 if hired_child==.

gen wage_men=pp_s3q28_c
gen wage_women=pp_s3q28_f
gen wage_child=pp_s3q28_i
gen hired_menph=ph_s10q01_b
gen hired_womenph=ph_s10q01_e
gen hired_childph=ph_s10q01_h
replace hired_menph=0 if hired_menph==.
replace hired_womenph=0 if hired_womenph==.
replace hired_childph=0 if hired_childph==.

gen wage_menph=ph_s10q01_c
gen wage_womenph=ph_s10q01_f
gen wage_childph=ph_s10q01_i
gen hh_lab1ph=ph_s10q02_b*ph_s10q02_c
gen hh_lab2ph=ph_s10q02_f*ph_s10q02_g
gen hh_lab3ph=ph_s10q02_j*ph_s10q02_k
gen hh_lab4ph=ph_s10q02_n*ph_s10q02_o
gen hh_lab5ph=ph_s10q02_r*ph_s10q02_s
gen hh_lab6ph=ph_s10q02_v*ph_s10q02_w
gen hh_lab7ph=ph_s10q02_z*ph_s10q02_ka
replace hh_lab1ph=0 if hh_lab1ph==.
replace hh_lab2ph=0 if hh_lab2ph==.
replace hh_lab3ph=0 if hh_lab3ph==.
replace hh_lab4ph=0 if hh_lab4ph==.
replace hh_lab5ph=0 if hh_lab5ph==.
replace hh_lab6ph=0 if hh_lab6ph==.
replace hh_lab7ph=0 if hh_lab7ph==.

gen tot_lab1=hh_lab1+hh_lab1ph
gen tot_lab2=hh_lab2+hh_lab2ph
gen tot_lab3=hh_lab3+hh_lab3ph
gen tot_lab4=hh_lab4+hh_lab4ph
gen tot_lab5=hh_lab5+hh_lab5ph
gen tot_lab6=hh_lab6+hh_lab6ph
gen tot_lab7=hh_lab7+hh_lab7ph

gen tot_hired_men=hired_men + hired_menph
gen tot_hired_women=hired_women + hired_womenph
gen tot_hired_child=hired_child + hired_childph
gen avg_wagemen=(wage_men +wage_menph)/2
gen avg_wagewomen=(wage_women +wage_womenph)/2
gen avg_wagechild=(wage_child +wage_childph)/2
drop hh_lab1-hh_lab7ph
drop pp_s2q03c_a-ph_s10q03_f pp_saq07 hh_s1q04h household_id hh_s1q00- hh_s1q04h 
drop r-conversion
duplicates drop
save "ETH_w2U.dta",replace
*****************************************************
*****************************************************
use "ETH_w3.dta",clear
gen r = saq01
tostring r,replace
tostring saq02, replace
tostring saq03, replace
gen unit=pp_s3q02_c
tostring unit, replace
gen uid=r+"_"+saq02+"_"+saq03+"_"+unit
merge m:1 uid using "ET_local_area_unit_conversion.dta"
drop if pp_s3q02_c>6
*create plot size and convert to sqmeters. Not all of the conversions made it
destring unit,replace
gen plot_size=pp_s3q02_a
replace plot_size=plot_size*2.47105 if unit==1
gen acres=(unit==1)
replace acres=1 if unit==3
replace acres=1 if unit==4
replace acres=1 if unit==5
replace acres=1 if unit==6
replace acres=1 if unit==7
replace acres=1 if region==3 & unit==4
replace acres=1 if region==4 & unit==4
replace acres=1 if region==8 & unit==4
replace acres=1 if region==3 & unit==5
replace acres=1 if region==3 & unit==6
replace acres=1 if region==5 & unit==4
*To get as many obs as possible average across all of the regions

replace plot_size=plot_size*291.4066*0.000247105 if unit==4
replace plot_size=plot_size*1197.805*0.000247105 if unit==5
replace plot_size=plot_size*1986.144*0.000247105 if unit==6
replace plot_size=plot_size*1609.978*0.000247105 if unit==3
*now take average by region

replace plot_size=plot_size*1947.582*0.000247105 if region==1 & unit==3
replace plot_size=plot_size*1941.238*0.000247105 if region==2 & unit==3
replace plot_size=plot_size*1472.163*0.000247105 if region==3 & unit==3
replace plot_size=plot_size*991.1986*0.000247105 if region==4 & unit==3
replace plot_size=plot_size*1476.523*0.000247105 if region==5 & unit==3
replace plot_size=plot_size*1205.46*0.000247105 if region==6 & unit==3
replace plot_size=plot_size*1042.535*0.000247105 if region==7 & unit==3
replace plot_size=plot_size*570*0.000247105 if region==8 & unit==3
replace plot_size=plot_size*1051.083*0.000247105 if region==9 & unit==3

replace plot_size=plot_size*304.4126*0.000247105 if region==3 & unit==4
replace plot_size=plot_size*172.02*0.000247105 if region==4 & unit==4
replace plot_size=plot_size*140*0.000247105 if region==8 & unit==4

replace plot_size=plot_size*1197.805*0.000247105 if region==3 & unit==5
replace plot_size=plot_size*2113.16*0.000247105 if region==3 & unit==6
replace plot_size=plot_size*843*0.000247105 if region==5 & unit==6
replace plot_size=plot_size*conversion*0.000247105 if _merge==3 // acres

drop ea_id ea_id2 individual_id2 _merg
gen hh_sex=hh_s1q03
gen plot_own=(pp_s2q03c_a==1)

replace plot_own=2 if pp_s2q03c_a==2
replace plot_own=3 if pp_s2q03c_a==2 &pp_s2q03c_b==1
replace plot_own=3 if pp_s2q03c_a==1 &pp_s2q03c_b==2
replace plot_own=4 if plot_own==0
gen plot_manager=(pp_s2q08a_a==1)
replace plot_manager=2 if pp_s2q08a_a==2
replace plot_manager=3 if pp_s2q08a_a==2 &pp_s2q08a_b==1
replace plot_manager=3 if pp_s2q08a_a==1 &pp_s2q08a_b==2
replace plot_manager=4 if plot_manager==0
gen plant_d=(pp_s3q10a==1)
replace plant_d=2 if pp_s3q10a==2
replace plant_d=3 if pp_s3q10a==2 &pp_s3q10b==1
replace plant_d=3 if pp_s3q10a==1 &pp_s3q10b==2
replace plant_d=4 if plant_d==0
gen output_d=(ph_s9q07a_1==1)
replace output_d=2 if ph_s9q07a_1==2
replace output_d=3 if ph_s9q07a_1==2 &ph_s9q07a_2==1
replace output_d=3 if ph_s9q07a_1==1 &ph_s9q07a_2==2
replace output_d=4 if output_d==0
*fert
replace pp_s3q16=0 if pp_s3q16==.
replace pp_s3q19=0 if pp_s3q19==.
gen inorg_fert=pp_s3q16+pp_s3q19
gen org_fert=(pp_s3q25==1)

gen hh_lab1=pp_s3q27_b*pp_s3q27_c
gen hh_lab2=pp_s3q27_f*pp_s3q27_g
gen hh_lab3=pp_s3q27_j*pp_s3q27_k
gen hh_lab4=pp_s3q27_n*pp_s3q27_o
replace hh_lab1=0 if hh_lab1==.
replace hh_lab2=0 if hh_lab2==.
replace hh_lab3=0 if hh_lab3==.
replace hh_lab4=0 if hh_lab4==.

gen hh_menl=pp_s3q29_b
gen hh_womenl=pp_s3q29_d
gen hh_childl=pp_s3q29_f
gen hired_men=pp_s3q28_b
gen hired_women=pp_s3q28_e
gen hired_child=pp_s3q28_h
replace hired_men=0 if hired_men==.
replace hired_women=0 if hired_women==.
replace hired_child=0 if hired_child==.

gen wage_men=pp_s3q28_c
gen wage_women=pp_s3q28_f
gen wage_child=pp_s3q28_i
gen hired_menph=ph_s10q01_b
gen hired_womenph=ph_s10q01_e
gen hired_childph=ph_s10q01_h
replace hired_menph=0 if hired_menph==.
replace hired_womenph=0 if hired_womenph==.
replace hired_childph=0 if hired_childph==.

gen wage_menph=ph_s10q01_c
gen wage_womenph=ph_s10q01_f
gen wage_childph=ph_s10q01_i
gen hh_lab1ph=ph_s10q02_b*ph_s10q02_c
gen hh_lab2ph=ph_s10q02_f*ph_s10q02_g
gen hh_lab3ph=ph_s10q02_j*ph_s10q02_k
gen hh_lab4ph=ph_s10q02_n*ph_s10q02_o

replace hh_lab1ph=0 if hh_lab1ph==.
replace hh_lab2ph=0 if hh_lab2ph==.
replace hh_lab3ph=0 if hh_lab3ph==.
replace hh_lab4ph=0 if hh_lab4ph==.

gen tot_lab1=hh_lab1+hh_lab1ph
gen tot_lab2=hh_lab2+hh_lab2ph
gen tot_lab3=hh_lab3+hh_lab3ph
gen tot_lab4=hh_lab4+hh_lab4ph


gen tot_hired_men=hired_men + hired_menph
gen tot_hired_women=hired_women + hired_womenph
gen tot_hired_child=hired_child + hired_childph
gen avg_wagemen=(wage_men +wage_menph)/2
gen avg_wagewomen=(wage_women +wage_womenph)/2
gen avg_wagechild=(wage_child +wage_childph)/2
drop hh_lab1-hh_lab4ph
drop pp_s2q03c_a-ph_s10q03_f pp_saq07 hh_s1q04h household_id hh_s1q00- hh_s1q04h
gen field_id2=holder_id+"_"+parcel_id+"_"+field_id
drop r-conversion
duplicates drop
save "ETH_w3U.dta",replace
*****************************************************
*****************************************************
*Combine both waves
set more off
use "ETH_w3U.dta",clear
merge 1:1 field_id2 using "ETH_w2U.dta"
drop _merge
gen country=1
save "ETH.dta",replace
rename  field_id2 plot_id
merge 1:1 plot_id using "MA.dta"
drop _merge
save "REP.dta",replace
gen output_w=(output_d==2)
gen output_j=(output_d==3)
gen output_m=(output_d==1)
gen plant_w=(plant_d==2)
gen plant_j=(plant_d==3)
gen plant_m=(plant_d==1)
gen plotown_w=(plot_own==2)
gen plotown_j=(plot_own==3)
gen plotown_m=(plot_own==1)

drop if output_d==4
drop if plant_d==4
drop if plot_own==4
bysort country: sum output_w-plotown_m //table 1
gen head_female=(hh_sex==2)
replace rural=(rural==1)
replace inorg_fert=inorg_fertquant if inorg_fert==.
drop inorg_fertquant
replace tot_lab8=0 if tot_lab8==.
replace tot_lab9=0 if tot_lab9==.
replace tot_lab10=0 if tot_lab10==.
replace tot_lab11=0 if tot_lab11==.
replace tot_lab12=0 if tot_lab12==.
replace education=0 if education==.
replace cereals=0 if cereals==.
replace inorg_fert=0 if inorg==.
replace org_fert=(org_fert==1)
gen lab_oth= tot_lab3+tot_lab4+tot_lab5+tot_lab6+tot_lab7+tot_lab8+tot_lab9+tot_lab10+tot_lab11+tot_lab12
gen hired_labor=tot_hired_men+tot_hired_women+tot_hired_child
bysort plot_own: sum head_female age education rural dist_road plot_size cereals org_fert inorg_fert tot_lab1 tot_lab2 lab_oth hired_lab if country==1
bysort plot_own: sum head_female age education rural dist_road plot_size cereals org_fert inorg_fert tot_lab1 tot_lab2 lab_oth hired_lab if country==2
gen plot_size2=plot_size*plot_size
replace inorg_fert=inorg_fert/100
replace HHID=household_id2 if HHID==""
encode HHID,gen(HHIDc)
save "Rep.dta",replace
xtset HHIDc
xtreg plant_w plotown_w plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road,cluster(HHID)
xtreg plant_m plotown_w  plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road ,cluster(HHID)
xtreg plant_j plotown_w  plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road ,cluster(HHID)
xtreg output_w plotown_w  plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road ,cluster(HHID)
xtreg output_m plotown_w  plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road ,cluster(HHID)
xtreg output_j plotown_w  plotown_j head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road ,cluster(HHID)


xtreg tot_lab1  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
xtreg tot_lab2  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
xtreg lab_oth  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
xtreg hired_labor  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)

bysort country: xtreg tot_lab1  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID) 
bysort country: xtreg tot_lab2  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID) 
bysort country: xtreg lab_oth  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID) 
bysort country: xtreg hired_labor  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)

*Bootstrap the hypotheses
program bootstrap, rclass
	use "Rep.dta",clear
	bsample
	reg tot_lab1  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_m4p=_b[plotown_j]
	return scalar b_m5p=_b[plant_j]
	return scalar b_m6p=_b[output_j]
	reg tot_lab2  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_f1p=_b[plotown_w]
	return scalar b_f2p=_b[plant_w]
	return scalar b_f3p=_b[output_w]
	return scalar b_f5p=_b[plant_j]
	return scalar b_f6p=_b[output_j]
	return scalar b_f4p=_b[plotown_j]
	use "Rep.dta",clear
	bsample
	drop if country==2
	reg tot_lab1  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_m4e=_b[plotown_j]
	return scalar b_m5e=_b[plant_j]
	return scalar b_m6e=_b[output_j]
	reg tot_lab2  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_f1e=_b[plotown_w]
	return scalar b_f2e=_b[plant_w]
	return scalar b_f3e=_b[output_w]
	return scalar b_f4e=_b[plotown_j]
	return scalar b_f5e=_b[plant_j]
	return scalar b_f6e=_b[output_j]	
	use "Rep.dta",clear
	bsample
	drop if country==1
	reg tot_lab1  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_m4m=_b[plotown_j]
	return scalar b_m5m=_b[plant_j]
	return scalar b_m6m=_b[output_j]
	reg tot_lab2  head_female age education plot_size plot_size2 cereals org_fert inorg_fert dist_road plotown_w plant_w output_w plotown_j plant_j output_j,cluster(HHID)
	return scalar b_f1m=_b[plotown_w]
	return scalar b_f2m=_b[plant_w]
	return scalar b_f3m=_b[output_w]
	return scalar b_f4m=_b[plotown_j]
	return scalar b_f5m=_b[plant_j]
	return scalar b_f6m=_b[output_j]	
end
simulate b_m4p=r(b_m4p) b_m5p=r(b_m5p) b_m6p=r(b_m6p) b_f1p=r(b_f1p) b_f2p=r(b_f2p) b_f3p=r(b_f3p) b_f4p=r(b_f4p) b_f5p=r(b_f5p) b_f6p=r(b_f6p) b_m4e=r(b_m4e) b_m5e=r(b_m5e) b_m6e=r(b_m6e) b_f1e=r(b_f1e) b_f2e=r(b_f2e) b_f3e=r(b_f3e) b_f4e=r(b_f4e) b_f5e=r(b_f5e) b_f6e=r(b_f6e) b_m4m=r(b_m4m) b_m5m=r(b_m5m) b_m6m=r(b_m6m) b_f1m=r(b_f1m) b_f2m=r(b_f2m) b_f3m=r(b_f3m) b_f4m=r(b_f4m) b_f5m=r(b_f5m) b_f6m=r(b_f6m), reps(1000): bootstrap
gen hyp1p=(-b_m4p)-(b_f1p-b_f4p)
gen hyp2p=(-b_m5p)-(b_f2p-b_f5p)
gen hyp3p=(-b_m6p)-(b_f3p-b_f6p)
gen hyp1e=(-b_m4e)-(b_f1e-b_f4e)
gen hyp2e=(-b_m5e)-(b_f2e-b_f5e)
gen hyp3e=(-b_m6e)-(b_f3e-b_f6e)
gen hyp1m=(-b_m4m)-(b_f1m-b_f4m)
gen hyp2m=(-b_m5m)-(b_f2m-b_f5m)
gen hyp3m=(-b_m6m)-(b_f3m-b_f6m)
sum hyp1p-hyp3m
egen hyp1pl=pctile(hyp1p),p(2.5)
egen hyp1pu=pctile(hyp1p),p(97.5)
egen hyp2pl=pctile(hyp2p),p(2.5)
egen hyp2pu=pctile(hyp2p),p(97.5)
egen hyp3pl=pctile(hyp3p),p(2.5)
egen hyp3pu=pctile(hyp3p),p(97.5)
egen hyp1el=pctile(hyp1e),p(2.5)
egen hyp1eu=pctile(hyp1e),p(97.5)
egen hyp2el=pctile(hyp2e),p(2.5)
egen hyp2eu=pctile(hyp2e),p(97.5)
egen hyp3el=pctile(hyp3e),p(2.5)
egen hyp3eu=pctile(hyp3e),p(97.5)
egen hyp1ml=pctile(hyp1m),p(2.5)
egen hyp1mu=pctile(hyp1m),p(97.5)
egen hyp2ml=pctile(hyp2m),p(2.5)
egen hyp2mu=pctile(hyp2m),p(97.5)
egen hyp3ml=pctile(hyp3m),p(2.5)
egen hyp3mu=pctile(hyp3m),p(97.5)
sum hyp1pl-hyp3mu
**********************************************************************************
*								Figures											 *
**********************************************************************************			
*Fig 1 is 2 bar graphs
use "Rep.dta",clear
ssc install splitvallabels
label define plotown 1 "Men own plot" 2 "Female own plot" 3 "Jointly owned plot"
label values plot_own plotown
label define output 1 "Men output rights" 2 "Women output rights" 3 "Joint output rights"
label values output_d output
label define plant 1 "Men planting rights" 2 "Women planting rights" 3 "Joint planting rights"
label values plant_d plant
ssc install catplot

*bar graph 1

splitvallabels plant_d 
catplot plot_own plant_d, ///
percent(plot_own) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent", size(small)) ///
blabel(bar, format(%4.1f)) ///
intensity(25) ///
asyvars recast(bar)
graph export "plant_d.png",replace
splitvallabels output_d 
catplot plot_own output_d, ///
percent(plot_own) ///
var1opts(label(labsize(small))) ///
var2opts(label(labsize(small)) relabel(`r(relabel)')) ///
ytitle("Percent", size(small)) ///
blabel(bar, format(%4.1f)) ///
intensity(25) ///
asyvars recast(bar)
graph export "output_d.png",replace

*create inverse hyperbolic sine
gen tot_lab1_IHS = log(tot_lab1 + sqrt(tot_lab1^2 + 1))
gen tot_lab2_IHS = log(tot_lab1 + sqrt(tot_lab2^2 + 1))
gen male_plots= tot_lab1_IHS if plot_own==1
gen female_plots= tot_lab1_IHS if plot_own==2
gen joint_plots= tot_lab1_IHS if plot_own==3

gen male_planting= tot_lab1_IHS if plant_d==1
gen female_planting= tot_lab1_IHS if plant_d==2
gen joint_planting= tot_lab1_IHS if plant_d==3

gen male_output= tot_lab1_IHS if output_d==1
gen female_output= tot_lab1_IHS if output_d==2
gen joint_output= tot_lab1_IHS if output_d==3

gen male_plots2= tot_lab2_IHS if plot_own==1
gen female_plots2= tot_lab2_IHS if plot_own==2
gen joint_plots2= tot_lab2_IHS if plot_own==3

gen male_planting2= tot_lab2_IHS if plant_d==1
gen female_planting2= tot_lab2_IHS if plant_d==2
gen joint_planting2= tot_lab2_IHS if plant_d==3

gen male_output2= tot_lab2_IHS if output_d==1
gen female_output2= tot_lab2_IHS if output_d==2
gen joint_output2= tot_lab2_IHS if output_d==3
twoway kdensity male_plots || kdensity female_plots || kdensity ///
joint_plots, xtitle("Male Labor Hours" (labsize(small))) 
gr export "kd_m1.png",replace
twoway kdensity male_planting || kdensity female_planting || kdensity ///
joint_planting, xtitle("Male Labor Hours" (labsize(small)))
gr export "kd_m2.png",replace
twoway kdensity male_output || kdensity female_output || kdensity ///
joint_output, xtitle("Male Labor Hours" (labsize(small)))
gr export "kd_m3.png",replace


twoway kdensity male_plots2 || kdensity female_plots2 || kdensity ///
joint_plots2, xtitle("Female Labor Hours" (labsize(small))) 
gr export "kd_w1.png",replace
twoway kdensity male_planting2 || kdensity female_planting2 || kdensity ///
joint_planting2, xtitle("Female Labor Hours" (labsize(small)))
gr export "kd_w2.png",replace
twoway kdensity male_output2 || kdensity female_output2 || kdensity ///
joint_output2, xtitle("Female Labor Hours" (labsize(small)))
gr export "kd_w3.png",replace

