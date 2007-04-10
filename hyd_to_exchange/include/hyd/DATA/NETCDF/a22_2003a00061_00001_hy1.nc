CDF       
      time      pressure   $   latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            61     CAST_NUMBER         1    BOTTOM_DEPTH_METERS         9   BOTTLE_NUMBERS        �     36     35     34     33     32     31     30     29     28     27     26     25     24     23     22     21     20     19     18     17     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1   BOTTLE_QUALITY_CODES      $                                       Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:50 2006 GMT     ORIGINAL_HEADER       �
BOTTLE,20060503WHPSIOSCD
#code : jjward hyd_to_exchange.pl 
#original files copied from HTML directory: 2006.05.03
#original HYD file: a22_2003ahy.txt   Mon May 23 12:18:22 2005
#original SUM file: a22_2003asu.txt   Wed May  3 18:23:14 2006
     WOCE_BOTTLE_FLAG_DESCRIPTION     �::1 = Bottle information unavailable.:2 = No problems noted.:3 = Leaking.:4 = Did not trip correctly.:5 = Not reported.:6 = Significant discrepancy in measured values between Gerard and Niskin bottles.:7 = Unknown problem.:8 = Pair did not trip correctly. Note that the Niskin bottle can trip at an unplanned depth while the Gerard trips correctly and vice versa.:9 = Samples not drawn from this bottle.:
      "WOCE_WATER_SAMPLE_FLAG_DESCRIPTION       �::1 = Sample for this measurement was drawn from water bottle but analysis not received.:2 = Acceptable measurement.:3 = Questionable measurement.:4 = Bad measurement.:5 = Not reported.:6 = Mean of replicate measurements.:7 = Manual chromatographic peak measurement.:8 = Irregular digital chromatographic peak integration.:9 = Sample not drawn for this measurement from this bottle.:
          '   ctd_raw                	long_name         ctd_raw    units                C_format      %8.1f      WHPO_Variable_Name        CTDRAW          #D   pressure               	long_name         	pressure       units         dbar       positive      down       C_format      %8.1f      WHPO_Variable_Name        CTDPRS          $d   temperature                	long_name         temperature    units         its-90     C_format      %8.4f      WHPO_Variable_Name        CTDTMP          %�   salinity               	long_name         	salinity       units         pss-78     C_format      %8.4f      WHPO_Variable_Name        CTDSAL     OBS_QC_VARIABLE       salinity_QC         &�   salinity_QC                	long_name         salinity_QC_flag       units         woce_flags     C_format      %1d       H  '�   bottle_salinity                	long_name         bottle_salinity    units         pss-78     C_format      %8.4f      WHPO_Variable_Name        SALNTY     OBS_QC_VARIABLE       bottle_salinity_QC          (   bottle_salinity_QC                 	long_name         bottle_salinity_QC_flag    units         woce_flags     C_format      %1d       H  ),   oxygen                 	long_name         oxygen     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        CTDOXY     OBS_QC_VARIABLE       
oxygen_QC           )t   	oxygen_QC                  	long_name         oxygen_QC_flag     units         woce_flags     C_format      %1d       H  *�   theta                  	long_name         theta      units         deg c      C_format      %8.4f      WHPO_Variable_Name        THETA           *�   bottle_oxygen                  	long_name         bottle_oxygen      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        OXYGEN     OBS_QC_VARIABLE       bottle_oxygen_QC            +�   bottle_oxygen_QC               	long_name         bottle_oxygen_QC_flag      units         woce_flags     C_format      %1d       H  -   silicate               	long_name         	silicate       units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        SILCAT     OBS_QC_VARIABLE       silicate_QC         -d   silicate_QC                	long_name         silicate_QC_flag       units         woce_flags     C_format      %1d       H  .�   nitrate                	long_name         nitrate    units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        NITRAT     OBS_QC_VARIABLE       nitrate_QC          .�   
nitrate_QC                 	long_name         nitrate_QC_flag    units         woce_flags     C_format      %1d       H  /�   nitrite                	long_name         nitrite    units         umol/kg    C_format      %8.2       WHPO_Variable_Name        NITRIT     OBS_QC_VARIABLE       nitrite_QC          04   
nitrite_QC                 	long_name         nitrite_QC_flag    units         woce_flags     C_format      %1d       H  1T   	phosphate                  	long_name         
phosphate      units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        PHSPHT     OBS_QC_VARIABLE       phosphate_QC            1�   phosphate_QC               	long_name         phosphate_QC_flag      units         woce_flags     C_format      %1d       H  2�   freon_11               	long_name         	freon_11       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-11     OBS_QC_VARIABLE       freon_11_QC         3   freon_11_QC                	long_name         freon_11_QC_flag       units         woce_flags     C_format      %1d       H  4$   freon_12               	long_name         	freon_12       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-12     OBS_QC_VARIABLE       freon_12_QC         4l   freon_12_QC                	long_name         freon_12_QC_flag       units         woce_flags     C_format      %1d       H  5�   	freon_113                  	long_name         
freon_113      units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC113     OBS_QC_VARIABLE       freon_113_QC            5�   freon_113_QC               	long_name         freon_113_QC_flag      units         woce_flags     C_format      %1d       H  6�   carbon_tetrachloride               	long_name         carbon_tetrachloride       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CCL4       OBS_QC_VARIABLE       carbon_tetrachloride_QC         7<   carbon_tetrachloride_QC                	long_name         carbon_tetrachloride_QC_flag       units         woce_flags     C_format      %1d       H  8\   
alkalinity                 	long_name         alkalinity     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        ALKALI     OBS_QC_VARIABLE       alkalinity_QC           8�   alkalinity_QC                  	long_name         alkalinity_QC_flag     units         woce_flags     C_format      %1d       H  9�   	total_co2                  	long_name         
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC            :   total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d       H  ;,   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       �r   data_max       �r   C_format      %10d            ;t   latitude               	long_name         	latitude       units         
degrees_N      data_min      B
��   data_max      B
��   C_format      %9.4f           ;x   	longitude                  	long_name         
longitude      units         
degrees_E      data_min      1�   data_max      1�   C_format      %9.4f           ;�   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��B   data_max      K��B   C_format      %8d         ;�   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      E�    data_max      E�    C_format      %4d         ;�   station                	long_name         STATION    units         unspecified    C_format      %s        (  ;�   cast               	long_name         CAST       units         unspecified    C_format      %s        (  ;�@333333@I�����@R�     @Y,�����@_@     @b�fffff@ffffff@l�����@q;33333@u�     @|)�����@�������@��fffff@��33333@������@�533333@�񙙙��@�G�����@�s33333@��     @�������@��fffff@�������@�������@�������@�z33333@��fffff@�^�����@�Rfffff@�Efffff@��ffff@��    @��ffff@��ffff@�     @��33333@333333@I�����@R�     @Y,�����@_@     @b�fffff@ffffff@l�����@q;33333@u�     @|)�����@�������@��fffff@��33333@������@�533333@�񙙙��@�G�����@�s33333@��     @�������@��fffff@�������@�������@�������@�z33333@��fffff@�^�����@�Rfffff@�Efffff@��ffff@��    @��ffff@��ffff@�     @��33333@8B�@��4@8?��v�@8,�_��@5Xy=�c@3���@3~p:�~�@3@��(�@2�J#9��@2�ԕ*�@2x���)@1��1���@0��䎊r@-w����@'�ݗ�+k@"�f�A�@<64�@��Mj@��	�@�����@u'�0@�C�\��@2��m\�@$��TɆ@
���(@
|����?@	{J#9�@�Z�c�@_ح��V@�Ov`@!a��e�@�33333@yrGE8�@=���v@<�쿱[@'�/�@�+J@B=��[@B>s����@B?iDg8@BO+I�@BR6��C@BPbM��@BOv_ح�@BM��ݗ�@BL<�쿱@BIN;�5�@B?4֡a�@B('RT`�@A�� ѷ@A��7��4@A�$tS��@A���TɆ@A��a��f@A��S&@A�@��@A}zxl"h@A{dZ�@Ay�^5?}@Az�䎊@A{F�]c�@Azڹ�Y�@Ay��u��@Aw��-V@AvOv_خ@At�/��@As�g��@As33333@Ar�0��@Aq�y��@Aqhr� �@Ap����@Ap_��F                                    @B<�u��"@B>�u@B?��-V@BN�m\��@BQ�"��`@BO�z�H@BO+I�@BM+��a@BK�Q�@BIA [�@B>�x���@B'ح��V@A�����@Aìq��@A�.H�@A��1&�@A��ߤ?�@A��g��	@A���@A}�=�K@A{��q�@Ay�_o�@Az&��IR@A{j��f�@Az�c�	@Ay�'RTa@Aw�͞��@Av_ح��@At��Z�@As��s�@As33333@Ar�L/�{@Aq�X�@Aqx���@Ap��'RT@ApU2a|                                    @i�fffff@j�����@jC33333@k�fffff@jfffff@i�33333@i�     @i�33333@j�����@i������@hc33333@gfffff@e     @bi�����@b&fffff@g�fffff@ls33333@nc33333@op     @p�����@ph     @p�fffff@p�     @pffffff@pffffff@ph     @p�     @p�     @p�     @p�33333@p�33333@p�fffff@pc33333@pNfffff@pfffff@p33333                                    @8BT`�d�@8<]c�e�@8(y=�c@5St�j~�@3�#��x@3we��ں@38����@2��{���@2�<64@2h�p:�@1��G�{@0�l�C��@-@ě��T@'{W>�6z@"��b��@�qu�"@���ݘ@f�A��@�@��@��8�YK@���)^@͞��%�@
�hr� �@	8}�H�@�&�x��@����@����n@�Q�@w���+@ {J#9��?���U�=?������?����E�?�TɅ�oj?�s�g��?�Dg8}�@j     @j33333@j&fffff@k�33333@i�33333@i�     @i�fffff@i�fffff@jL�����@i\�����@h�����@gi�����@d������@b������@b<�����@g������@l\�����@n�33333@o������@p333333@p������@p�fffff@p�33333@pa�����@pi�����@pt�����@p�     @p�fffff@p������@p������@p������@p�33333@pp     @pY�����@p&fffff@p33333                                    ?ٙ�����?�Q��R?ᙙ����?��G�z�?�      ?�=p��
=?�z�G�{?�=p��
=?�z�G�{?�\(�?��G�z�@z�G�{@�
=p��@"\(�@)\(��@*��
=q@(��
=p�@'Ǯz�H@'��
=q@(z�G�@(�(�\@*�Q�@,�
=p��@1aG�z�@1޸Q�@3.z�G�@4�\(�@5��Q�@7��\)@9��Q�@;���R@=�
=p��@@��\(��@A���
=q@C�G�z�@D+��Q�                                    ?�
=p��
?�
=p��
?�
=p��
?�z�G�{?�z�G�?񙙙���?�\(�\@�z�G�@(�\)@z�G�@G�z�H@z�G�@)���R@3ffffff@7J=p��
@5�     @3��\(��@2�
=p��@2J=p��
@1��G�{@1�z�G�@1�Q��@1���R@2.z�G�@2+��Q�@28Q��@2�Q�@2\(�@2��R@28Q��@2z�G�{@2Ǯz�H@3J=p��
@3�
=p��@4@     @4ffffff                                                                    ?�z�G�{?��Q��?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{                                                                                                                                                                                            ?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�������?��Q��?�(�\)?�(�\)?�z�G�{?У�
=p�?�=p��
=?�z�G�?��G�z�?���Q�?��\(�?�Q��R?�\(�\?�
=p��
?�Q��?�\(�?�ffffff?�Q��?�333333?�333333?�333333?�333333?�333333?�333333?��Q�?��
=p��?�(�\)?�������?��Q�?���Q�?�z�G�                                    ?���+?���E��?���E��@ffffff@ȴ9Xb@�/��w@��"��`@333333@G�z�H@�+J@��Q�@(�\)@ ȴ9Xb?�j~��"�?��/��w?�"��`A�?��`A�7L?����n�?���Q�?�t�j~��?�+I�^?�z�G�?�?|�hs?��;dZ�?�+I�^?��+J?����+?�r� ě�?�$�/�?�/��v�?�&�x���?�1&�y?ߍO�;dZ?�-V�?�^5?|�?д9XbN                                    ?�O�;d?�j~��"�?���+?����+?�E����?�Q��R?��+I�?���O�;d?��G�z�?�bM��?�=p��
>?��-V?�bM���?�\(��?�x���F?�"��`A�?�\(�\?�����o?���Q�?��Q�?�-?�7KƧ�?� ě��?�dZ�1?Ұ ě��?д9XbN?�|�hr�?� ě��T?У�
=p�?��`A�7L?�1&�x��?� ě��T?�\(�\?ʟ�vȴ9?° ě��?�-V�                                    ?��/��w?�?|�hs?�n��O�?�Z�1'?° ě��?�$�/�?�"��`A�?�� ě��?��t�j~�?�� ě��?��$�/?����l�?��-V?��1&�y?���S���?�bM��?��+J?�bM��?�XbM��?�^5?|�?�\(��?�?|�hs?� ě��T?��t�j~�?��O�;dZ?�n��O�;?��t�j~�?�������?��+I�?��vȴ9X?���S���?�hr� Ĝ��8     ?��1&�y?���vȴ9?��$�/                                 	   ��8     ?�V�t���8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8      	  	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	@���������8     @��33333��8     @��33333��8     @��fffff��8     @��fffff��8     @��33333��8     @�f�����@�B�����@�#     ��8     @�>fffff��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8       	  	  	  	  	  	    	  	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	@��     ��8     @��     ��8     @�G33333��8     @�P�������8     @�S�������8     @�x�������8     @�������@��     @��������8     @��     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8       	  	  	  	  	  	    	  	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 �r@A^ߤ?���P�5?|�1��  Z    61                                    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     