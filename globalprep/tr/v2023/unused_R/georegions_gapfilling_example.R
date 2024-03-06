### Gapfilling using UN georegions (not used v2023)

# To round out some gapfilling, we could use georegions. 
# This has a very low correlation with the data, but it was the simplest viable option discovered. 
# We decided ultimately just to leave values that would have been gapfilled by georegion as NAs since it did not seem to be reliable enough.
# This used to be in the main Rmd, to gapfill proportions, before gapfilling was done before proportions are calculated, so will need to be edited to be used before proportions


# the below ended up not being used (v2023)
# gapfill missing data using UN georegion data
# prepare the georegion data
georegions <- georegions
georegion_labels <- georegion_labels

tourism_props_geo_gf <- tourism_props_downup_gf %>%
  left_join(georegions, by = 'rgn_id') %>%
  left_join(georegion_labels, by = 'rgn_id') %>%
  select(-r0)

# the below shows the low R-squared with georegions
summary(lm(Ap ~ r1_label + r2_label, data = tourism_props_geo_gf))
#
# Call:
# lm(formula = Ap ~ r1_label + r2_label, data = tourism_props_geo_gf)
#
# Residuals:
#    Min     1Q Median     3Q    Max
# -23100   -745   -101      5 463002
#
# Coefficients: (5 not defined because of singularities)
#                                         Estimate Std. Error t value Pr(>|t|)
# (Intercept)                               215.60    1187.25   0.182  0.85590
# r1_labelAmericas                          -29.46    3141.16  -0.009  0.99252
# r1_labelAsia                             3660.65    1592.86   2.298  0.02160
# r1_labelEurope                           6786.93    2189.17   3.100  0.00195
# r1_labelLatin America and the Caribbean  -113.48    1716.76  -0.066  0.94730
# r1_labelOceania                          -187.87    3141.16  -0.060  0.95231
# r2_labelCaribbean                         746.66    1471.11   0.508  0.61179
# r2_labelCentral America                   218.51    1911.03   0.114  0.90897
# r2_labelEastern Africa                   -120.19    1760.97  -0.068  0.94559
# r2_labelEastern Asia                    -3347.02    2314.37  -1.446  0.14819
# r2_labelEastern Europe                  -2168.00    2601.13  -0.833  0.40462
# r2_labelMelanesia                         -18.69    3440.97  -0.005  0.99567
# r2_labelMicronesia                         51.47    3440.97   0.015  0.98807
# r2_labelMiddle Africa                    -110.76    2056.37  -0.054  0.95705
# r2_labelNorthern Africa                    95.93    2056.37   0.047  0.96279
# r2_labelNorthern America                      NA         NA      NA       NA
# r2_labelNorthern Europe                 -6240.07    2252.64  -2.770  0.00563
# r2_labelPolynesia                         -12.61    3297.53  -0.004  0.99695
# r2_labelSouth America                         NA         NA      NA       NA
# r2_labelSouth-Eastern Asia              -2272.44    1679.02  -1.353  0.17598
# r2_labelSouthern Africa                    60.55    3141.16   0.019  0.98462
# r2_labelSouthern Asia                   -3792.93    1986.64  -1.909  0.05630
# r2_labelSouthern Europe                 16141.80    2252.64   7.166 8.99e-13
# r2_labelWestern Africa                        NA         NA      NA       NA
# r2_labelWestern Asia                          NA         NA      NA       NA
# r2_labelWestern Europe                        NA         NA      NA       NA
#
# (Intercept)
# r1_labelAmericas
# r1_labelAsia                            *
# r1_labelEurope                          **
# r1_labelLatin America and the Caribbean
# r1_labelOceania
# r2_labelCaribbean
# r2_labelCentral America
# r2_labelEastern Africa
# r2_labelEastern Asia
# r2_labelEastern Europe
# r2_labelMelanesia
# r2_labelMicronesia
# r2_labelMiddle Africa
# r2_labelNorthern Africa
# r2_labelNorthern America
# r2_labelNorthern Europe                 **
# r2_labelPolynesia
# r2_labelSouth America
# r2_labelSouth-Eastern Asia
# r2_labelSouthern Africa
# r2_labelSouthern Asia                   .
# r2_labelSouthern Europe                 ***
# r2_labelWestern Africa
# r2_labelWestern Asia
# r2_labelWestern Europe
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# Residual standard error: 21370 on 4515 degrees of freedom
#   (135 observations deleted due to missingness)
# Multiple R-squared:  0.06147,	Adjusted R-squared:  0.05731
# F-statistic: 14.79 on 20 and 4515 DF,  p-value: < 2.2e-16




# calculate two different gapfill columns using r2 and r1
tourism_props_geo_gf <- tourism_props_geo_gf %>%
  group_by(year, r2) %>%
  mutate(Ep_pred_r2 = mean(Ep, na.rm=TRUE)) %>%
  ungroup() %>%
  group_by(year, r1) %>%
  mutate(Ep_pred_r1 = mean(Ep, na.rm=TRUE)) %>%
  ungroup()

# first gapfill with r2, if no value available use r1; create column indicating whether value was gapfilled and if so, by what method.
tourism_props_geo_gf <- tourism_props_geo_gf %>%
  mutate(Ap_all = ifelse(is.na(Ap), Ap_pred_r2, Ap)) %>%
  mutate(Ap_all = ifelse(is.na(Ap_all), Ap_pred_r1, Ap_all)) %>%
  mutate(gapfilled = case_when(is.na(Ap) & !is.na(Ap_all) ~ "gapfilled",
         TRUE ~ gapfilled)) %>%
  mutate(method = case_when(is.na(Ap) & !is.na(Ap_pred_r2) ~ "UN georegion (r2)",
                            is.na(Ap) & is.na(Ap_pred_r2) & !is.na(Ap_pred_r1) ~ "UN georegion (r1)",
                            TRUE ~ method))
