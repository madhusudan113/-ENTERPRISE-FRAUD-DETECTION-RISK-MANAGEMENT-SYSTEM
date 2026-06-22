INSERT INTO customer VALUES(101,'Madhu Sudan','9999999999','madhu@gmail.com','ACTIVE',SYSDATE);

INSERT INTO location VALUES(1,'Mumbai','Maharashtra','India');
INSERT INTO location VALUES(2,'Delhi','Delhi','India');

INSERT INTO merchant VALUES(1,'Amazon','ECOMMERCE');

INSERT INTO device VALUES(1,101,'Samsung M34','MOBILE',SYSDATE);

INSERT INTO transaction_master
VALUES(1001,101,50000,'UPI',1,1,1,SYSDATE,'SUCCESS');

COMMIT;
