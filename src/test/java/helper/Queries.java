package helper;

public class Queries {

    public static final String query =  "SELECT tc1.receipt_number,tc1.cod_corresponsal as corresponsal, tc1.terminal_id as terminal,\n" +
            "    tt.\"name\" as transaction_type ,\n" +
            "    fe.name as entidad, ts.name as estado, tc1.closure, \n" +
            "    (SELECT SUM(tc2.full_amount) \n" +
            "    FROM voucherdigital.public.transaction_corresponsalia tc2 \n" +
            "    WHERE tc2.receipt_number IN ('%s')) as total_amount,\n" +
            "    tc1.full_amount as individual_amount\n" +
            "FROM \n" +
            "    voucherdigital.public.transaction_corresponsalia tc1\n" +
            "LEFT JOIN\n" +
            "    voucherdigital.public.financial_entity fe ON tc1.financial_entity = fe.code\n" +
            "Left join \n" +
            "    voucherdigital.public.transaction_type tt on tc1.transaction_type = tt.code  \n" +
            "Left join \n" +
            "    voucherdigital.public.transaction_state ts on tc1.state = ts.code\n" +
            "WHERE \n" +
            "    tc1.receipt_number IN ('%s')\n" +
            "GROUP BY \n" +
            "    tc1.receipt_number, tc1.full_amount, fe.name,tt.\"name\",ts.name, tc1.cod_corresponsal, tc1.terminal_id,tc1.closure;";
}
