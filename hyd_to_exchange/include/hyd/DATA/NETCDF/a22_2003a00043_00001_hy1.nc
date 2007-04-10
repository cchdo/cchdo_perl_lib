CDF       
      time      pressure   $   latitude      	longitude         string_dimension   (         EXPOCODE      316N200310     Conventions       COARDS/WOCE    WOCE_VERSION      3.0    WOCE_ID       A22    	DATA_TYPE         	WOCE BOT       STATION_NUMBER            43     CAST_NUMBER         1    BOTTOM_DEPTH_METERS         �   BOTTLE_NUMBERS        �     36     35     34     33     32     31     30     29     28     27     26     25     24     23     22     21     20     19     18     17     16     15     14     13     12     11     10      9      8      7      6      5      4      3      2      1   BOTTLE_QUALITY_CODES      $    	                                   Creation_Time         ?Diggs EXBOT-to-NetCDF Code v0.1e: Thu May  4 01:27:49 2006 GMT     ORIGINAL_HEADER       �
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
total_co2      units         umol/kg    C_format      %8.1f      WHPO_Variable_Name        TCO2       OBS_QC_VARIABLE       total_co2_QC            :   total_co2_QC               	long_name         total_co2_QC_flag      units         woce_flags     C_format      %1d       H  ;,   time                	long_name         time       units         "minutes since 1980-01-01 00:00:00      data_min       �O�   data_max       �O�   C_format      %10d            ;t   latitude               	long_name         	latitude       units         
degrees_N      data_min      A��   data_max      A��   C_format      %9.4f           ;x   	longitude                  	long_name         
longitude      units         
degrees_E      data_min      ��   data_max      ��   C_format      %9.4f           ;�   	woce_date                   	long_name         
WOCE date      units         yyyymmdd UTC       data_min      K��?   data_max      K��?   C_format      %8d         ;�   	woce_time                   	long_name         
WOCE time      units         	hhmm UTC       data_min      D��    data_max      D��    C_format      %4d         ;�   station                	long_name         STATION    units         unspecified    C_format      %s        (  ;�   cast               	long_name         CAST       units         unspecified    C_format      %s        (  ;�@������@8�����@I�����@R������@X�33333@b�33333@i#33333@oY�����@r������@y)�����@T�����@��fffff@�{33333@�+33333@�o�����@��     @�!33333@�w�����@�͙����@�(fffff@�Ffffff@��     @��fffff@�}�����@�qfffff@�f33333@�Vfffff@�L     @�Bfffff@������@�������@��L����@�������@���3333@�z�����@�������@������@8�����@I�����@R������@X�33333@b�33333@i#33333@oY�����@r������@y)�����@T�����@��fffff@�{33333@�+33333@�o�����@��     @�!33333@�w�����@�͙����@�(fffff@�Ffffff@��     @��fffff@�}�����@�qfffff@�f33333@�Vfffff@�L     @�Bfffff@������@�������@��L����@�������@���3333@�z�����@�������@<&�a��f@;���3�@;��_p@9��S���@8�I�^5@@6$�*�1@4W
=p��@39����@2��y��@1����@/�]�c�A@+;dZ�@&Z��S&@ ��z�H@)�y��@㢜w�k@D���S�@e��@^5?|�@V�+J@L/�{J#@h���@	$tS��M@q����@_o��@���7��@�g��	@;���A@Õ�$�@xl"h	�@
	� �@�RT`�e@	� ѷ@ �:)�y�@ ��rGE9@ ��)^�@BB��ᰊ@BD��*0@BO1���@BX�4֡b@B_|�hs@Bsa@N�@Bf��IQ�@BR��)_@BKC��%@B;�6��@Bl�C��@A����@A�C��%@A�˒:)�@A�_o� @A�o hی@A�_��F@A��Q�@A��/��@A�t�j~�@A��>BZ�@A~E����@A{xF�]@AyG�z�@Awo���@Av$�/�@At����>@At�t�j@Asg��	l@Ar��`A�@Aq���o@Ap��-�@An쿱[W@Amzxl"h@Al�hr�@Al�3��                                    @B?�rGE9@BDI�^5?@BM%F
�L��8     @B^��,<�@Br�g��	@BfOv_�@BRW���&@BK�s�@B;xF�]@BKƧ�@A�MjO@A�=�K^@A��͞��@A��E��@A��'RTa@A�bM��@A�IQ���@A���u�@A�����@A�=p��
@A~c�	@A{~���$@AyTɅ�o@AwiDg8@Av($x@At�J�M@At"h	ԕ@As@N���@Ar�G�{@Aq���o@Ap�-�@An�1���@AmjOv@Al��Z�@Al�o h�    	                                @`�     @h�33333@i�fffff@i������@i������@hP     @gp     @g`     @g������@gl�����@e�fffff@b�33333@b6fffff@b      @e������@j#33333@l������@n�     @offfff@o`     @oc33333@oə����@o�     @p�����@p6fffff@p>fffff@pNfffff@px     @p������@py�����@pS33333@pfffff@o������@oFfffff@o      @o                                          @<&l�!-@;�?�@;��u@9���o@8滘��@6��>B[@4MO�;dZ@3�kP��@2|L�_@1�����@/�e+��@*���$tT@&)7KƧ�@ U��?@�@��4n@sg��	l@���҈�@�n.��3@�bM��@z���>B@��G�{@	�A [�@��Q�@��x���@�����@�ߤ?��@�z�G�@ ����o@ � ѷ?��\��N<?���1���?�t�j~��?���7��4?�\����>?�ԕ*�0?����o @h������@h������@i�     ��8     @i������@h������@g�����@g�33333@h�����@g�fffff@e�     @b`     @b`     @bfffff@e�fffff@j&fffff@m�����@n�fffff@o&fffff@oy�����@o�     @o������@o������@p33333@pP     @pP     @ph     @p�fffff@p�     @p�     @pd�����@p;33333@o������@offffff@o<�����@o333333    	                                ?�\(�\?�Q��?�ffffff��8     ?�\(�\?���Q�?�z�G�?�      ?�z�G�?��Q��@�Q�@333333@#
=p��
@/��Q�@0��
=p�@,�p��
=@*Q��R@)�fffff@+�(�\@.��Q�@2333333@4��
=p�@7�z�G�@9z�G�{@9�\(�@<(�\)@=Y�����@<�z�G�@>8Q��@?���R@A�
=p��@C��G�{@G]p��
=@J
=p��@K%�Q�@K��\(��    	                                ?���
=p�?��Q��        ��8             ?�      ?�z�G�{@	\(��@Q��R@p��
=q@$�fffff@1�����@4ٙ����@9���
=q@8}p��
=@5c�
=p�@3�\(�@3z�G�@2��
=q@2�z�G�@3+��Q�@3Q��R@3�     @3\(�\@3(�\)@3h�\)@3O\(�@3�Q�@3&fffff@3Y�����@3�z�G�@4�     @5u\(�@6+��Q�@6������@6�         	                                                        ��8             ?���Q�?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{?�z�G�{    	                                ?�z�G�{?�z�G�{?�z�G�{��8     ?�z�G�{?�z�G�{?��Q��?��Q��?�
=p��
?�333333?���Q�?�      ?�Q��R?�ffffff?�������?�z�G�?�Q��R?�z�G�?��Q�?�z�G�?��
=p��?�(�\)?�z�G�{?���
=p�?�Q��R?���
=p�?���
=p�?�Q��R?�z�G�{?���
=p�?�G�z�H?�z�G�?�333333?�(�\)?�z�G�{?���
=p�    	                                ?���S���?�;dZ�?��+I���8     @ V�t�@���+@���+@�+I�@�"��`B@�t�j@��l�C�?��1&�y?��/��w?��l�C��?�r� ě�?�����+?��`A�7L?�z�G�?����l�?�^5?|�?����E�?° ě��?���"��`?��Q�?�&�x���?��+J?�$�/��?�^5?|�?�\(�\?��G�z�?����+?Õ�$�/?��+J?��`A�7L?�;dZ�?�/��v�    	                                ?��hr�!?�$�/�?�-V��8     ?��;dZ�?�"��`A�?��t�j?��-?���"��`?��-?���"��`?�I�^5??�l�C��?�������?�r� ě�?ӕ�$�/?�-V?ى7KƧ�?���`A�7?��G�z�?��+J?�� ě��?��-V?��j~��#?�bM���?��+J?�?|�hs?�hr� Ĝ?�5?|�h?��-V?����+?��O�;dZ?� ě��T?�z�G�{?�z�G�{?�����+    	                                ?�ě��S�?�-V�?\(���8     ?��Q�?�ě��S�?���S���?�z�G�{?��+I�?��O�;dZ?��1&�y?��Q��?�n��O�;?x�t�j~�?tz�G�{?�t�j~��?��Q��?��vȴ9X?�z�G�{?��1&�y?pbM���?�n��O�;?x�t�j~�?�z�G�{?��Q��?|�1&�y?tz�G�{?��1&�y?��t�j~�?��t�j~�?��Q��?�z�G�{?�bM���?tz�G�{?|�1&�y?|�1&�y    	                                ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8      	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	@��33333��8     @��     ��8     @���������8     @��fffff��8     @���������8     @���������8     @�B     @�)�����@�&33333��8     ��8     @� fffff��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8       	  	  	  	  	  	    	 	  	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	@�������@��33333@���������8     @�33333@�L�����@�xfffff@�r�����@�s33333@�������@��fffff@��fffff@��fffff@�$     @�fffff��8     ��8     @���������8     ��8     @�뙙�����8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8     ��8         	            	 	  	 	  	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 �O�@8�33333�P���1�~  �    43                                    1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     