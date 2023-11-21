package helper;

import com.github.javafaker.Faker;

import java.math.BigInteger;
import java.util.Random;

public class DataGenerator {

    public static int getRandomNumReceipt() {
        Faker faker = new Faker();
        int NumReceipt = faker.random().nextInt(111111, 999999);
        return NumReceipt;
    }

    public static int getRandomValueReceipt() {
        Faker faker = new Faker();
        int ValueReceipt = faker.random().nextInt(0, 9999999);
        return ValueReceipt;
    }

    public static String getRandomValueCajero() {
        Faker faker = new Faker();
        String ValueCajero = faker.random().nextInt(0, 999999) + "aBcD";
        return ValueCajero;
    }

    public static String getRandomValueCard() {
        Faker faker = new Faker();
        String ValueCard = faker.random().nextInt(1111, 9999) + "" + faker.random().nextInt(1111, 9999) + "" + "****"  + "" + faker.random().nextInt(1111, 9999);
        return ValueCard;
    }

    public static BigInteger RandomNumber(int n) {
        Random random = new Random();
        BigInteger numeroAleatorio = BigInteger.ZERO;
        for (int i = 0; i < n; i++) {
            numeroAleatorio = numeroAleatorio.multiply(BigInteger.TEN).add(BigInteger.valueOf(random.nextInt(10)));
        }
        return numeroAleatorio;
    }

    public static BigInteger RandomNumber(int n, int x) {
        int tipo = x;
        Random random = new Random();
        BigInteger numeroAleatorio = BigInteger.ZERO;
        if (tipo == 1) {
            for (int i = 0; i < n; i++) {
                numeroAleatorio = numeroAleatorio.multiply(BigInteger.TEN).add(BigInteger.valueOf(random.nextInt(10)));
            }
        } else if (tipo == 0) {
            for (int i = 0; i < n; i++) {
                numeroAleatorio = numeroAleatorio.multiply(BigInteger.TEN).add(BigInteger.valueOf(random.nextInt(10)).negate());
            }
        } else if (tipo == 9) {
            BigInteger numeroBigInteger = new BigInteger("3177928280");
            numeroBigInteger = numeroBigInteger;
        } else System.out.println("No se envio el valor valido, revisa la implementacion de tu funcion");
        return numeroAleatorio;
    }

    public static BigInteger NumberCelular() {

        BigInteger numeroBigInteger = new BigInteger("3177928280");


        return numeroBigInteger;
    }
}
