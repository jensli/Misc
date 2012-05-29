
class ExprTest {
  
  Expr simplify( Expr e )
  {
    switch (e) {
      case UnOp("-", UnOp("-", null)):
          return ((e as UnOp).arg as UnOp).arg
      
      case BinOp("+", null, Number(0)):
          return (e as BinOp).left
      
      case BinOp("*", null, Number(1)):
          return (e as BinOp).left
      
      default: return e
    }
  }
  
  static Facet? typeFacet( Type t, Type facetType )
  {
    return t.facets().find { it.typeof == facetType }
  }
  
  static Str serializableToStr(Obj? obj)
  {
    return Buf().writeObj(obj).readAllStr
  }
  
  
  static Facet? slotFacet( Slot t, Type facetType )
  {
    return t.facets().find { it.typeof == facetType }
  }
  
  static Bool testEquals( Obj ths, Obj? other )
  {
    if ( other == null ) return false
    if ( !other.typeof.fits( ths.typeof ) ) return false
    
//    PatternClass? patFac := typeFacet( ths.typeof, PatternClass# )
//    PatternWildcard? classWild := typeFacet(ths, PatternWildcard# )
    
    return ths.typeof.fields.all( |Field field -> Bool| {
        
        if ( field.hasFacet( PatternExclude# ) ) return true
        
        Obj? wildcard := null
        Bool hasWildcard := false
      
        PatternWildcard? wildFacet := slotFacet( field, PatternWildcard# )
        
        if ( wildFacet != null ) {
          wildcard = wildFacet.value
          hasWildcard = true
        } else {
          PatternWildcard? classWildFacet := typeFacet( field.type, PatternWildcard# )
          if ( classWildFacet != null ) {
            wildcard = classWildFacet.value
            hasWildcard = true
          }
        }
        
        valThis := field.get( ths )
        valOther := field.get( other )
        
        return (hasWildcard && (valThis == wildcard || valOther == wildcard))
            || valThis == valOther
      } )
  }
  

//  scala> simplifyTop(UnOp("-", UnOp("-", Var("x"))))
//  res4: Expr = Var(x)
//
//    def simplifyTop(expr: Expr): Expr = expr match {
//      case UnOp("-", UnOp("-", e))  => e   // Double negation
//      case BinOp("+", e, Number(0)) => e   // Adding zero
//      case BinOp("*", e, Number(1)) => e   // Multiplying by one
//      case _ => expr
//    }


  Void main()
  {
    echo( "Begin test pattern" )
    
    expr := UnOp("-", UnOp("-", Var("x") ) )
    
    echo( "Before: " )
    Env.cur.out.writeObj( expr, ["indent":2] )
    echo()
    echo( "After: " )
    Env.cur.out.writeObj( simplify( expr ), ["indent":2] )
    echo()
    echo( "End test pattern" )
  }
  
}


@Serializable
@PatternWildcard{ value = null }
const class Expr {
  
  override Bool equals( Obj? other ) {
    return PatternUtil.testEquals( this, other )
  }
  
  override Str toStr() {
    return ExprTest.serializableToStr( this )
  }
}

const class Var : Expr {
  const Str? name
  
  new make( Str? name ) {
    this.name = name
  }
}

const class Number : Expr {
  const Int? num
  
  new make( Int? num ) {
    this.num = num
  }
}

const class UnOp : Expr {
  const Str? opr
  const Expr? arg
  
  new make( Str? opr, Expr? arg ) {
    this.opr = opr
    this.arg = arg
  }
}

const class BinOp : Expr {
  const Str? opr
  const Expr? left
  const Expr? right
  
  new make( Str? opr, Expr? left, Expr? right ) {
    this.opr = opr
    this.left = left
    this.right = right
  }
  
}

  
  
