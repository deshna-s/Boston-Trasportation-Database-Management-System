-- non cluster index

-- For the USERS Table
CREATE NONCLUSTERED INDEX idx_user_status ON USERS(User_Status);

-- For the RECHARGE Table
CREATE NONCLUSTERED INDEX idx_recharge_renewal_date ON RECHARGE(Renewal_Date);

-- For the CARD Table
CREATE NONCLUSTERED INDEX idx_card_expiry ON CARD(Card_Expiry);

-- For the PASS Table
CREATE NONCLUSTERED INDEX idx_pass_expiry ON PASS(Pass_Expiry);

-- For the OPERATIONS Table
CREATE NONCLUSTERED INDEX idx_operations_user_status ON OPERATIONS(OP_User_Status);
CREATE NONCLUSTERED INDEX idx_operations_activity_log ON OPERATIONS(Activity_Log);
