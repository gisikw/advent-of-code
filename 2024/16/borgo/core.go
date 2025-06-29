package main
import (
 "reflect"
 "fmt"
)

func make_Result_Ok [T any, E any] (arg_0 T) Result[T, E] {
    return Result [T, E] { tag: Result_Ok, Ok: arg_0 }
}

func make_Result_Err [T any, E any] (arg_0 E) Result[T, E] {
    return Result [T, E] { tag: Result_Err, Err: arg_0 }
}

func make_Option_Some [T any] (arg_0 T) Option[T] {
    return Option [T] { tag: Option_Some, Some: arg_0 }
}

func make_Option_None [T any] () Option[T] {
    return Option [T] { tag: Option_None,  }
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
type ResultTag int
const (
Result_Ok ResultTag = iota
Result_Err
)
type Result[T any, E any] struct {
            tag ResultTag
Ok T
Err E
} 
 func (r Result[T, E]) IsOk  () bool {


var var3 bool
 var1_subject := r
var2_matches := 0



if var2_matches != 2 {
    var2_matches = 0

    var4_match_pat := 0
if var4_match_pat != 1 { var4_match_pat = 2 /* wildcard */ }

if var4_match_pat != 1 && var1_subject.tag == Result_Ok {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  true
    }
}


if var2_matches != 2 {
    var2_matches = 0

    var6_match_pat := 0
if var6_match_pat != 1 { var6_match_pat = 2 /* wildcard */ }

if var6_match_pat != 1 && var1_subject.tag == Result_Err {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  false
    }
}

return var3  
}
 func (r Result[T, E]) Unwrap  () T {

  if r.tag == Result_Err {
   inspect(r.Err)
   panic("Unwrapped Err value")
 }
 return r.Ok 
} 
type OptionTag int
const (
Option_Some OptionTag = iota
Option_None
)
type Option[T any] struct {
            tag OptionTag
Some T
} 
 func (o Option[T]) IsSome  () bool {


var var3 bool
 var1_subject := o
var2_matches := 0



if var2_matches != 2 {
    var2_matches = 0

    var4_match_pat := 0
if var4_match_pat != 1 { var4_match_pat = 2 /* wildcard */ }

if var4_match_pat != 1 && var1_subject.tag == Option_Some {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  true
    }
}


if var2_matches != 2 {
    var2_matches = 0

    var6_match_pat := 0

if var6_match_pat != 1 && var1_subject.tag == Option_None {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  false
    }
}

return var3  
}
 func (o Option[T]) IsNone  () bool {


return !o.IsSome()  
}
 func (o Option[T]) UnwrapOr  (def T) T {


var var3 T
 var1_subject := o
var2_matches := 0



if var2_matches != 2 {
    var2_matches = 0

    var4_match_pat := 0
x := var1_subject.Some

if var4_match_pat != 1 && var1_subject.tag == Option_Some {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  x
    }
}


if var2_matches != 2 {
    var2_matches = 0

    var6_match_pat := 0

if var6_match_pat != 1 && var1_subject.tag == Option_None {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  def
    }
}

return var3  
}
 func (o Option[T]) UnwrapOrElse  (f func () T) T {


var var3 T
 var1_subject := o
var2_matches := 0



if var2_matches != 2 {
    var2_matches = 0

    var4_match_pat := 0
x := var1_subject.Some

if var4_match_pat != 1 && var1_subject.tag == Option_Some {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  x
    }
}


if var2_matches != 2 {
    var2_matches = 0

    var6_match_pat := 0

if var6_match_pat != 1 && var1_subject.tag == Option_None {
    var2_matches = 2
} else {
    var2_matches = 1
}

    _ = var1_subject

    if var2_matches == 2 {
        
        var3 =  f()
    }
}

return var3  
}
 func (o Option[T]) Unwrap  () T {

  if o.tag == Option_None {
  panic("Unwrapped None value")
 }
 return o.Some 
} 
 func  Option_ToOption [T any] (value T, check bool) (T, bool) {


var var1 Option[T]
if check {
    

var1 =  make_Option_Some[T](value)
    
} else {
    
var1 =  make_Option_None[T]()
    
}

        if var1.IsSome() {
            return var1.Some, true
        }
        return *new(T), false
              
}
type Tuple2[T any, Y any] struct {
  first T
  second Y
} 
type Tuple3[T any, Y any, Z any] struct {
  first T
  second Y
  third Z
} 
type Tuple4[T any, X any, Y any, Z any] struct {
  first T
  second X
  third Y
  fourth Z
} 
 func  zeroValue [T any] () T {

  var m T
 return m 
}
 func  assertEq [T any] (a T, b T)  {

  if !reflect.DeepEqual(a, b) {
 inspect(a);
 inspect(b);
 panic("something wrong")
 } 
}
 func  inspect [T any] (a T) T {

  fmt.Printf("%+v\n", a);
 return a 
}
 func  Debug_unreachable [T any] () T {

 panic("unreachable code") 
}
 func  Result_fromError  (e error) (struct{}, error) {

  if e != nil {
   return struct{}{}, e
 }
 return struct{}{}, nil 
}
 func  Slice_Len [T any] (xs []T) int {

 return len(xs) 
}
 func  Slice_Enumerate [T any] (xs []T) []T {

 return xs 
}
 func  Slice_Set [T any] (xs []T, index int, item T)  {

  xs[index] = item 
}
 func  Slice_Append [T any] (xs []T, item T) []T {

  return append(xs, item) 
}
 func  Slice_Get [T any] (xs []T, i int) (T, bool) {

  if i < 0 || i >= len(xs) {
   return *new(T), false
 }
 return xs[i], true 
} 
 func  Map_new [K comparable, V any] () map[K]V {

  return map[K]V{} 
}
 func  Map_Len [K comparable, V any] (m map[K]V) int {

  return len(m) 
}
 func  Map_Insert [K comparable, V any] (m map[K]V, k K, v V)  {

  m[k] = v 
}
 func  Map_Get [K comparable, V any] (m map[K]V, k K) (V, bool) {

  v, ok := m[k]
 return v, ok 
} 
 func  Channel_new [T any] () Tuple2[chan<- T, <-chan T] {

  ch := make(chan T)
 return Tuple2[chan<- T, <-chan T]{ first: ch, second: ch } 
}
 func  Sender_Send [T any] (ch chan<- T, value T)  {

  ch <- value 
}
 func  Sender_Close [T any] (ch chan<- T)  {

  close(ch) 
} 
 func  Receiver_Recv [T any] (ch <-chan T) T {

  return <- ch 
} 
 func  string_Enumerate  (s string) []rune {

  return []rune(s) 
} 