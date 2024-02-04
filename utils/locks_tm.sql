SELECT * 
FROM v$lock v, all_objects d 
WHERE v.TYPE = 'TM'
	AND v.id1 = d.object_id 
	AND d.object_name = 'AMORT_USER_TEST'
	AND d.owner = 'RISK_MAIN';
