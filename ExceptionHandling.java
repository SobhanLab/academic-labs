public class ExceptionHandling {

    public static void main(String[] args) {
        int arr[] = {1,2,2,4,5};
        try{
        System.out.println(arr[10]);
        }
        catch(Exception e){
        System.out.println("Here is an Error=> " +e);
        }
        finally{
            System.out.println("I am last Line.");
        }
    }
}