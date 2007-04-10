CDF       
      time      pressure   $   latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            42     CAST_NUMBER         1    BOTTOM_DEPTH_METERS         �   BOTTLE_NUMBERS        �     36     35     34     33     32     31     30     29     28     27     26     25     24     23     22     21     20     19     18     17     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1   BOTTLE_QUALITY_CODES      $    	                                   Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:49 2006 GMT     ORIGINAL_HEADER       �
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
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC            :   total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d       H  ;,   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       �N#   data_max       �N#   C_format      %10d            ;t   latitude               	long_name         	latitude       units         
degrees_N      data_min      A���   data_max      A���   C_format      %9.4f           ;x   	longitude                  	long_name         
longitude      units         
degrees_E      data_min      �   data_max      �   C_format      %9.4f           ;�   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��?   data_max      K��?   C_format      %8d         ;�   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      D�`    data_max      D�`    C_format      %4d         ;�   station                	long_name         STATION    units         unspecified    C_format      %s        (  ;�   cast               	long_name         CAST       units         unspecified    C_format      %s        (  ;�@������@Is33333@R������@YL�����@_9�����@d�����@i�����@offffff@r�fffff@y!�����@L�����@�������@�|�����@�^fffff@������@�&fffff@������@�q33333@��     @�]33333@��fffff@��fffff@��33333@�������@�|fffff@�o�����@�c�����@�Y33333@�K     @�>�����@�������@������@��L����@��fffff@�������@�P�3333@������@Is33333@R������@YL�����@_9�����@d�����@i�����@offffff@r�fffff@y!�����@L�����@�������@�|�����@�^fffff@������@�&fffff@������@�q33333@��     @�]33333@��fffff@��fffff@��33333@�������@�|fffff@�o�����@�c�����@�Y33333@�K     @�>�����@�������@������@��L����@��fffff@�������@�P�3333@<Dg8~@;5L�_�@:�$�/@9��g��	@8���o @6o�	�@4R-V@3F����@2�/�{J#@1[�l�C�@/�X�e@*���Fs�@%��q��@!M�qv@qu�!�S@U2a|�@ [�7@'���@f��,<�@�ڹ�Y�@.H�@H��@
����@	*͞��&@u��!�.@�5?|�@��2�W�@ٳ�|��@U�=�@�a@N�@t���#�@H���@��vȴ@�V�u@ ���ᰊ@ n���t@BGo���@B[@N���@Bh���U�@Bfc�	@B|�O�M@B�h	ԕ@Be�K]�@BT�_��@BK��Q�@B5�-V@B!�.H�@A��W���@A�<64@A�C,�z@A���w�k@A�bM��@A��1���@A�!-w2@A���@A~�A��@A~�6z�@A}��1��@A|V�Ϫ�@A{@N���@Ay*0U2a@AwE8�4�@Au�S���@At��Z�@As��s�@Asj��f�@Ar͞��&@Ar6��C@Aq|�Q@Ao�䎊r@Am��n/@Al��7��                                    @BG�@BYA [�@BhN���U��8     @B|��7��@B��s�@Bf�Fs��@BT9XbN@BK�:)�z@B5�$�/@B�o i@Aⅇ�ݘ@A�8�4֡@A�n��P@A��U�=@A�1&�x�@A���+@A�C,�zx@A�6��@A~�Ϫ͟@A~���t@A}Ϫ͞�@A|`�d��@A{=�K^@Ay:��S@AwiDg8@Au�E��@At֡a��@AtPH�@Ast�j~�@Ar��)_@Ar���ݘ@AqXbM�@Ao���+@Am�ڹ�Z@Al֡a��    	                                @c     @i������@j�����@i�33333@i<�����@h�����@g6fffff@gi�����@h33333@gvfffff@e������@c�fffff@b)�����@avfffff@c�     @jI�����@mfffff@o33333@o�33333@p333333@o������@p<�����@p!�����@p     @p&fffff@p.fffff@px     @p�fffff@p�33333@p������@p������@ps33333@pS33333@p�����@oVfffff@o                                          @<�rGE@;2GE8�5@:��1&�@9���D�@8����F@6g1���@4Hy=�c@3;�u%@2~p:�~�@1JkP��|@/�z�G�@*��PH�@%{=�K^@!C,�zx@
=p��
@�xF�@���@�zxl"h@���rG@f1���.@J���D�@�˒:)�@	S����@��q��@���a@@�r� Ĝ@�O�;dZ@�{J#9�@ �Ov_�@ n��P?���Fs��?�&��IQ�?�R�<64?������?��kP��|?��͞��&@h|�����@i�fffff@j&fffff��8     @i)�����@hC33333@gFfffff@g陙���@g������@gc33333@e������@cffffff@b333333@a�     @c�fffff@j������@m<�����@n�33333@r������@p>fffff@p1�����@pD�����@pA�����@p�����@p0     @pX     @p~fffff@p������@p�33333@p�     @p�33333@p�33333@p^fffff@p�����@o�fffff@oFfffff    	                                ?���Q�?�Q��?�ffffff��8     ?�Q��R?ٙ�����?�      ?�z�G�?�z�G�{?��Q��@Q��R@      @$�     @.��Q�@2      @-      @*8Q��@)k��Q�@*�Q�@+      @-aG�z�@.�\(�@2\(��@6s33333@8W
=p��@9��
=p�@:=p��
=@:��
=q@<
=p��
@<��
=q@>�=p��
@@xQ��@B!G�z�@ENz�G�@I�Q��@Kj=p��
    	                                ?ə�����?�z�G�{?�p��
=q��8     ?ə�����?޸Q��?��Q��@Q��R@=p��
=@333333@%�
=p��@0�\(�@5������@9�33333@:��R@5Y�����@3Ǯz�H@2�Q��@2�z�G�@2��Q�@2�\(�@2������@2�G�z�@3Y�����@3c�
=p�@3Tz�G�@3#�
=p�@3�z�H@2�z�G�@2޸Q�@3(�\@3nz�G�@3�fffff@4��Q�@6#�
=p�@6��\(��    	                                                        ��8     ?�
=p��
?�z�G�{?�z�G�{                ?�z�G�{?�z�G�{?�z�G�{                                                                                                                                                                                                    	                                ?�z�G�{?�z�G�{?�z�G�{��8     ?�z�G�{?�z�G�{?�������?�
=p��
?�
=p��
?�\(��?��G�z�?�ffffff?��\(�?�z�G�?�
=p��
?�z�G�?�Q��R?�\(�\?�
=p��
?��G�z�?�333333?�333333?��Q�?�(�\)?�Q��R?�Q��R?�      ?�      ?�(�\)?�(�\)?�Q��R?�������?�G�z�H?��\(�?�      ?�z�G�{    	                                ?���$�/?�
=p��
?��+I���8     ?���$�/@ �hr� �@=p��
=@���l�@r� ě�@r� ě�@j~��"�?��"��`B?��l�C��?�1&�x�?Ͼvȴ9X?�S����?����n�?�hr� Ĝ?���"��`?�      ?�vȴ9X?��1&�?�z�G�{?ǍO�;dZ        ?�V�t�?Ұ ě��?�1&�x�?�/��v�?�$�/����8     ��8     ��8     ��8     ��8     ��8         	                                ?��t�j?�V�t�?��C��%��8     ?�p��
=q?��Q�?�+I�?�������?���E��?�
=p��
?�;dZ�?�7KƧ�?��/��w?���vȴ?�M����?�9XbM�?ٙ�����?ܛ��S��?ݲ-V?�(�\)?ӥ�S���?�XbM��?�
=p��
?��hr�!        ?��Q��?° ě��?�333333?ě��S��?Ł$�/��8     ��8     ��8     ��8     ��8     ��8         	                                ?�����+?����l�D?���Q���8     ?�\(��?��hr�!?���E��?���vȴ9?��1&�y?���vȴ9?�t�j~��?�t�j~��?��1&�y?�bM���?��1&�y?�n��O�;?�t�j~��?��vȴ9X?�bM���?���Q�?��$�/?�n��O�;?�bM���?pbM���?PbM���?x�t�j~�?��t�j~�?���vȴ9?�bM���?�n��O�;��8     ��8     ��8     ��8     ��8     ��8         	                                ?��Q�?��
=p��?�����+��8     ?�z�G�?�n��O�;?ա���o?�333333?�j~��"�?�|�hr�?Ձ$�/?���Q�?˥�S���?�����+?ɺ^5?|�?�A�7Kƨ?��"��`B?��O�;dZ?��^5?|�?��t�j~�?�7KƧ�?�vȴ9X?�\(��?�V�u?|�1&�y?��t�j?�n��O�?�(�\)?�\(�\?�(�\)��8     ��8     ��8     ��8     ��8     ��8         	                           	 	 	 	 	 	@�������@�������@�͙������8     @��33333@�噙���@��33333@��33333@��33333@��     @�������@�`fffff@�@�����@�#33333@�33333@� �����@������@�fffff@�33333@�fffff@�33333@�33333@�!33333@�*fffff@�)33333@�(33333@�)�����@�(     @�)�����@�,�����@�=�����@�=     @�Dfffff@�P33333@�V�����@�]�����    	                                @��33333@��     @���������8     @�&�����@�^�����@�s     @�o�����@�u33333@�������@�������@�������@������@�!     @�$�����@�      @��33333@�陙���@��     @�������@��33333@��fffff@��33333@�������@�򙙙��@�������@��33333@�򙙙��@��     @�������@��fffff@� �����@�
33333@�33333@�'�����@�0         	                                 �N#@86�!�.I�P�9XbN1�~  �    42                                    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     