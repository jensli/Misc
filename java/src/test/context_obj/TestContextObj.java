package test.context_obj;


interface IRes1 {
    int getInt();

    interface Getter {
        IRes1 getRes1();
    }
}


class Res1 implements IRes1 {
    public int getInt() {
        return 3;
    }
}


////////////////////////////////////////////////////

interface IRes2 {
    String getString();

    interface Getter {
        IRes2 getRes2();
    }
}


class Res2 implements IRes2 {
    public String getString() {
        return "Privjet mir!";
    }
}

////////////////////////////////////////////////////

interface IContext extends IRes1.Getter,
                           IRes2.Getter
{}

class Context implements IContext {

    @Override
    public IRes1 getRes1() {
        return new Res1();
    }

    @Override
    public IRes2 getRes2() {
        return new Res2();
    }

}

////////////////////////////////////////////////////

class ClientObj {

    private IRes1 res1;
    private IRes2 res2;

    public
        <T_CONTEXT extends
            IRes1.Getter
          & IRes2.Getter>

    ClientObj(T_CONTEXT context) {
        res1 = context.getRes1();
        res2 = context.getRes2();
    }
}


public class TestContextObj {



    public static void main(String[] args) {
        IContext context = new Context();

        ClientObj obj = new ClientObj(context);
    }
}
