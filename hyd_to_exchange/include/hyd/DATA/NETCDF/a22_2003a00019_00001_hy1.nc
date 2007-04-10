CDF       
      time      pressure      latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            19     CAST_NUMBER         1    BOTTOM_DEPTH_METERS         	�   BOTTLE_NUMBERS        �     28     27     26     25     24     23     22     21     20     19     18     17     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1   BOTTLE_QUALITY_CODES                                     Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:49 2006 GMT     ORIGINAL_HEADER       �
BOTTLE,20060503WHPSIOSCD
#code : jjward hyd_to_exchange.pl 
#original files copied from HTML directory: 2006.05.03
#original HYD file: a22_2003ahy.txt   Mon May 23 12:18:22 2005
#original SUM file: a22_2003asu.txt   Wed May  3 18:23:14 2006
     WOCE_BOTTLE_FLAG_DESCRIPTION     �::1 = Bottle information unavailable.:2 = No problems noted.:3 = Leaking.:4 = Did not trip correctly.:5 = Not reported.:6 = Significant discrepancy in measured values between Gerard and Niskin bottles.:7 = Unknown problem.:8 = Pair did not trip correctly. Note that the Niskin bottle can trip at an unplanned depth while the Gerard trips correctly and vice versa.:9 = Samples not drawn from this bottle.:
      "WOCE_WATER_SAMPLE_FLAG_DESCRIPTION       �::1 = Sample for this measurement was drawn from water bottle but analysis not received.:2 = Acceptable measurement.:3 = Questionable measurement.:4 = Bad measurement.:5 = Not reported.:6 = Mean of replicate measurements.:7 = Manual chromatographic peak measurement.:8 = Irregular digital chromatographic peak integration.:9 = Sample not drawn for this measurement from this bottle.:
          '   ctd_raw                	long_name         ctd_raw    units                C_format      %8.1f      WHPO_Variable_Name        CTDRAW        �  "�   pressure               	long_name         	pressure       units         dbar       positive      down       C_format      %8.1f      WHPO_Variable_Name        CTDPRS        �  #�   temperature                	long_name         temperature    units         its-90     C_format      %8.4f      WHPO_Variable_Name        CTDTMP        �  $�   salinity               	long_name         	salinity       units         pss-78     C_format      %8.4f      WHPO_Variable_Name        CTDSAL     OBS_QC_VARIABLE       salinity_QC       �  %�   salinity_QC                	long_name         salinity_QC_flag       units         woce_flags     C_format      %1d       8  &|   bottle_salinity                	long_name         bottle_salinity    units         pss-78     C_format      %8.4f      WHPO_Variable_Name        SALNTY     OBS_QC_VARIABLE       bottle_salinity_QC        �  &�   bottle_salinity_QC                 	long_name         bottle_salinity_QC_flag    units         woce_flags     C_format      %1d       8  '�   oxygen                 	long_name         oxygen     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        CTDOXY     OBS_QC_VARIABLE       
oxygen_QC         �  '�   	oxygen_QC                  	long_name         oxygen_QC_flag     units         woce_flags     C_format      %1d       8  (�   theta                  	long_name         theta      units         deg c      C_format      %8.4f      WHPO_Variable_Name        THETA         �  (�   bottle_oxygen                  	long_name         bottle_oxygen      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        OXYGEN     OBS_QC_VARIABLE       bottle_oxygen_QC          �  )�   bottle_oxygen_QC               	long_name         bottle_oxygen_QC_flag      units         woce_flags     C_format      %1d       8  *�   silicate               	long_name         	silicate       units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        SILCAT     OBS_QC_VARIABLE       silicate_QC       �  *�   silicate_QC                	long_name         silicate_QC_flag       units         woce_flags     C_format      %1d       8  +�   nitrate                	long_name         nitrate    units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        NITRAT     OBS_QC_VARIABLE       nitrate_QC        �  +�   
nitrate_QC                 	long_name         nitrate_QC_flag    units         woce_flags     C_format      %1d       8  ,�   nitrite                	long_name         nitrite    units         umol/kg    C_format      %8.2       WHPO_Variable_Name        NITRIT     OBS_QC_VARIABLE       nitrite_QC        �  -   
nitrite_QC                 	long_name         nitrite_QC_flag    units         woce_flags     C_format      %1d       8  -�   	phosphate                  	long_name         
phosphate      units         umol/kg    C_format      %8.2f      WHPO_Variable_Name        PHSPHT     OBS_QC_VARIABLE       phosphate_QC          �  .$   phosphate_QC               	long_name         phosphate_QC_flag      units         woce_flags     C_format      %1d       8  /   freon_11               	long_name         	freon_11       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-11     OBS_QC_VARIABLE       freon_11_QC       �  /<   freon_11_QC                	long_name         freon_11_QC_flag       units         woce_flags     C_format      %1d       8  0   freon_12               	long_name         	freon_12       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC-12     OBS_QC_VARIABLE       freon_12_QC       �  0T   freon_12_QC                	long_name         freon_12_QC_flag       units         woce_flags     C_format      %1d       8  14   	freon_113                  	long_name         
freon_113      units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CFC113     OBS_QC_VARIABLE       freon_113_QC          �  1l   freon_113_QC               	long_name         freon_113_QC_flag      units         woce_flags     C_format      %1d       8  2L   carbon_tetrachloride               	long_name         carbon_tetrachloride       units         pmol/kg    C_format      %8.3f      WHPO_Variable_Name        CCL4       OBS_QC_VARIABLE       carbon_tetrachloride_QC       �  2�   carbon_tetrachloride_QC                	long_name         carbon_tetrachloride_QC_flag       units         woce_flags     C_format      %1d       8  3d   
alkalinity                 	long_name         alkalinity     units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        ALKALI     OBS_QC_VARIABLE       alkalinity_QC         �  3�   alkalinity_QC                  	long_name         alkalinity_QC_flag     units         woce_flags     C_format      %1d       8  4|   	total_co2                  	long_name         
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC          �  4�   total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d       8  5�   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       �1�   data_max       �1�   C_format      %10d            5�   latitude               	long_name         	latitude       units         
degrees_N      data_min      A�+   data_max      A�+   C_format      %9.4f           5�   	longitude                  	long_name         
longitude      units         
degrees_E      data_min       i   data_max       i   C_format      %9.4f           5�   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��   data_max      K��   C_format      %8d         5�   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      D�     data_max      D�     C_format      %4d         5�   station                	long_name         STATION    units         unspecified    C_format      %s        (  5�   cast               	long_name         CAST       units         unspecified    C_format      %s        (  6@ffffff@9�����@I      @R�     @Y      @_�����@b�fffff@i     @oFfffff@r�33333@y�����@I�����@��fffff@�������@��33333@������@�533333@��     @�T�����@������@�������@�ə����@��33333@�'�����@�������@�1�����@�]33333@��     @ffffff@9�����@I      @R�     @Y      @_�����@b�fffff@i     @oFfffff@r�33333@y�����@I�����@��fffff@�������@��33333@������@�533333@��     @�T�����@������@�������@�ə����@��33333@�'�����@�������@�1�����@�]33333@��     @=0�d��8@=-B����@;ޤ��T�@;X�e+�@:GE8�5@9�s�P@7����?@4����A@2��t�j@1�{J#9�@.���|��@)w�kQ@#�����@T��Z�@|�Q�@_o���@�64�@���p:�@�E���@q�i�B�@��,<��@����$t@��g��	@�����@��J�M@m�C�\�@h�\)@m�hr�!@A�v_ح�@A�_o��@BE��ݗ�@Bg�@B��J�@B�j��f�@B�L�_�@BtPH�@BPhۋ�q@B;�5�Xy@B��+j�@A�3���@A��*�1@Aw�͞��@An\��N<@At��E�@Ay���-�@A{@N���@A|���#�@A}(���@A|��q�j@A}�qv@A}Ϫ͞�@A}����@A}���v@A}(���@A}qu�"@A}(���                            @A�$tS��@A�-�q@B?RT`�e@Bf�-@B�����@B���҉@B��#��x@Bsn.��3@BO��3�@B;"��`B@B��u�@A�N;�5�@A�/�{J#@Aw�	�@AnR�<6@Au+��a@Az����@A{=�K^@A|�쿱[@A}?|�h@A|�_��@A}�S���@A~_o� @A}�S���@A}�8�YK@A}��[@A|�!-w@A}5�Xy>                            @d�     @hVfffff@h������@i0     @h�fffff@g������@g\�����@e�33333@f      @fi�����@dfffff@a`     @_      @_�33333@a      @dC33333@g������@i#33333@jFfffff@k33333@j������@m	�����@m)�����@ms33333@m<�����@k�     @k�fffff@l                                 @=0�n��@=+���m]@;ۥ�S��@;Tg8}�@:����?@8���҈�@7��zxl"@4��N;�6@2��9Xb@1�L/�{J@.ٌ~($@)���"��@#e����@
���D�@+j��f�@�]c�f@��1&�@,��[W?@�
�L/�@�/�V��@[=�K^@2䎊q�@t�j~�@�qu�@�*�0�@Xy=�c@/��v�@��u��@h333333@h6fffff@i33333@iC33333@h�     @g�fffff@gS33333@e�     @f�fffff@fC33333@cٙ����@`�fffff@_y�����@`	�����@aY�����@dvfffff@g�fffff@i�����@jS33333@kI�����@j������@m      @mc33333@m������@mL�����@l�����@k�33333@lFfffff                            ?�Q��R?�Q��R?���Q�?���Q�?�p��
=q?�
=p��
?�z�G�{?�p��
=q?�Q��?��\(�@z�G�{@�\(�@+=p��
=@2�fffff@5��
=p�@6J=p��
@7�     @8      @7�����@60��
=q@9k��Q�@3޸Q�@3���Q�@3u\(�@4�z�G�@85\(�@9�Q�@8k��Q�                            ?�z�G�{��z�G�{?��Q��?�z�G�{?���Q�?��G�z�?��Q�@������@�Q�@������@(\(��@3Tz�G�@:
=p��@=aG�z�@=��
=q@;\(�\@8�
=p��@7�
=p��@6�G�z�@5�G�z�@6aG�z�@4��z�H@4aG�z�@4.z�G�@4nz�G�@5Tz�G�@5nz�G�@58Q��                                                            ?��Q��?���Q�?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{                                                                                                                                                            ?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�������?���
=p�?�(�\)?�
=p��
?�Q��?�Q��?�ffffff?��\(�?��z�G�?�G�z�H?�ffffff?�p��
=p?�Q��R?�\(�\?�(�\)?���Q�?�\(��?�������?�\(��?�
=p��
?�333333?��G�z�                            ?��-?�V�t�?�Q��R?�~��"��?��\(�?�t�j~��?�p��
=p?����E�@���S��@$�/��@ 5?|�h?�� ě��?�z�G�?�hr� Ĝ?�1&�x��?Õ�$�/?����E�?�ȴ9Xb?�XbM��?�333333?�
=p��
?��/��w?�7KƧ�?�=p��
=?�9XbM�?���+?�l�C��?�I�^5?}                            ?�n��O�?�j~��#?$�/?��l�C��?��`A�7L?��Q�?�^5?|�?��Q�?��/��w?�n��P?�9XbM�?ꟾvȴ9?�V�u?�V�u?�5?|�h?�ȴ9Xb?��`A�7L?��-V?��E���?ļj~��#?�/��v�?щ7KƧ�?ҏ\(�?�333333?љ�����?\(�?�5?|�h?�n��O�;                            ?�
=p��
?�Q��R?��$�/?�E����?�^5?|�?��l�C��?���"��`?��-V?��1&�y?�bM���?��1&�y?��Q��?�z�G�{?tz�G�{?tz�G�{?PbM���?pbM���?x�t�j~�?�n��O�;?�n��O�;?PbM���?��$�/?�t�j~��?�z�G�{?�bM���?�n��O�;?|�1&�y?��+I�                            ?�1&�y?�z�G�?�^5?|�?�$�/��?�/��v�?�7KƧ�?�1&�x�?��"��`B?Гt�j~�?Ѓn��P?�ě��S�?̬1&�y?�I�^5?�z�G�{?�|�hr�?��
=p��?�M����?��/��w?ҟ�vȴ9?�n��O�;?Ƈ+I�?�z�G�?�A�7Kƨ?���l�D?���"��`?� ě��T?�r� ě�?���l�C�                            @�     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8       	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	@���������8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8       	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 �1�@1��`A�7�P�qu�1�4  q    19                                    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             