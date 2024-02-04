begin
    core_expression_utils.TEST_EXPRESSION( hRecipients => 'mail@mail.ru',
                                            hChainName => '', 
                                            hProcName => '', 
                                            --hProcName => 'BANKLED_MODEL#10', 
                                            hScenName => 'TEST_SHORT_LINE', 
                                            --hExpName => 'GENERIC#D#10',
                                            hExpName => ''                                            
                                            
                                            ,hSubsts => '#DBLINK_SOURCE->@DBLINK_KRMDB101,#DBLINK_RECEIVE->@DBLINK_KRMDB101,#DBLINK->@DBLINK_KRMDB101,#DBLNK_RECEIVE->@DBLINK_KRMDB101'

                                             );  
end;
