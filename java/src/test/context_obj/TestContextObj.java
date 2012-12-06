package test.context_obj;
/*

The Context IoC pattern is nice in that the client makes it explicit which dependencies it uses. It's not so nice because of two reasons:

x Each client needs its own context interface.
x Also, the global context class needs to implement the interfaces of all client classes that need the dependencies. This creates a dependency from the context class to the clients.

The classes in the link below is an attempt to solve those problems.

Here each publicly available service declares a "Getter" interface, which is implemented by the context class.

The clients use a constructor with a type parameter constrained to types that implements the getters of the services it depends on.

So the two problems mentioned above is resolved:
    x There is an extra interface per service instead of per client.
    x The context class depend on the getters, not on the clients context interfaces.

*/

interface IService1 {
    int getInt();

    interface Getter {
        IService1 getService1();
    }
}


class Service1 implements IService1 {
    public int getInt() {
        return 3;
    }
}


////////////////////////////////////////////////////

interface IService2 {
    String getString();

    interface Getter {
        IService2 getService2(int dummyParam);
    }
}


class Service2 implements IService2 {
    public String getString() {
        return "Privjet mir!";
    }
}

////////////////////////////////////////////////////

interface IContext extends IService1.Getter,
                           IService2.Getter
{}

class Context implements IContext {

    @Override
    public IService1 getService1() {
        return new Service1();
    }

    @Override
    public IService2 getService2(int dummyParam) {
        return new Service2();
    }
}

////////////////////////////////////////////////////

class ClientObj {

    private IService1 service1;
    private IService2 service2;

    public
        <T_CONTEXT extends
            IService1.Getter
          & IService2.Getter>

    ClientObj(T_CONTEXT context) {
        service1 = context.getService1();
        service2 = context.getService2(2);
    }
}


public class TestContextObj {



    public static void main(String[] args) {
        IContext context = new Context();

        ClientObj obj = new ClientObj(context);
    }
}
