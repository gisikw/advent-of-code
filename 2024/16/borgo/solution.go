package main
import (
 "strings"
 "fmt"
 "os"
)

func make_Dir_North  () Dir {
    return Dir  { tag: Dir_North,  }
}

func make_Dir_East  () Dir {
    return Dir  { tag: Dir_East,  }
}

func make_Dir_South  () Dir {
    return Dir  { tag: Dir_South,  }
}

func make_Dir_West  () Dir {
    return Dir  { tag: Dir_West,  }
}
 
 
 
type State struct {
  row int
  col int
  facing Dir
} 
type DirTag int
const (
Dir_North DirTag = iota
Dir_East
Dir_South
Dir_West
)
type Dir struct {
            tag DirTag
} 
 func  main  ()  {



inputFile := os.Args[1]
 


part := os.Args[2]
 
var content string


var3_result := func() Result[[]byte, error] {
    var1_check, var2_err := os.ReadFile(inputFile)
    if var2_err != nil {
        return make_Result_Err[[]byte, error](var2_err)
    }
    return make_Result_Ok[[]byte, error](var1_check)
}()

 var4_subject := var3_result
var5_matches := 0



if var5_matches != 2 {
    var5_matches = 0

    var6_match_pat := 0
bytes := var4_subject.Ok

if var6_match_pat != 1 && var4_subject.tag == Result_Ok {
    var5_matches = 2
} else {
    var5_matches = 1
}

    _ = var4_subject

    if var5_matches == 2 {
        

        content =  string(bytes)
    }
}


if var5_matches != 2 {
    var5_matches = 0

    var8_match_pat := 0
e := var4_subject.Err

if var8_match_pat != 1 && var4_subject.tag == Result_Err {
    var5_matches = 2
} else {
    var5_matches = 1
}

    _ = var4_subject

    if var5_matches == 2 {
        {


 fmt.Printf("Error reading file: %s\n", e)
return 

}
        
    }
}
 


trimmed := strings.TrimSpace(content)
 





trimmed = strings.Replace(trimmed, "E", "Z", 1)
 





trimmed = strings.Replace(trimmed, "S", "E", 1)
 





trimmed = strings.Replace(trimmed, "Z", "S", 1)
 



lines := strings.Split(trimmed, "\n")
 

start_row := 0
 

start_col := 0
 

grid := [][]rune {  }
 

for r, line := range Slice_Enumerate[string](lines) {
    
row := []rune {  }
 

for c, char := range string_Enumerate(line) {
    

row = Slice_Append[rune](row, char) 


if char == 'S' {
    {

start_row = r 

start_col = c 
}
    
}   
} 


grid = Slice_Append[[]rune](grid, row)  
} 



initial_state := State { row: start_row, 
col: start_col, 
facing: make_Dir_West(),  }
 

queue := []State { initial_state }
 

visited := Map_new[State, bool]()
 

previous := Map_new[State, []State]()
 

distances := Map_new[State, int]()
 


 Map_Insert[State, int](distances, initial_state, 0)


 Map_Insert[State, []State](previous, initial_state, []State {  })

for (true) {
    
state := zeroValue[State]()
 

min_score := 10000000000000000
 

for _, el := range queue {
    

if visited[el] {
    continue 
    
}  


var12_result := func() Option[int] {
    var10_check, var11_err := Map_Get[State, int](distances, el)
    if var11_err == false {
        return make_Option_None[int]()
    }
    return make_Option_Some[int](var10_check)
}()

score := var12_result
 



if score.IsSome() && score.Unwrap() < min_score {
    {

min_score = score.Unwrap() 

state = el 
}
    
}   
} 



visited[state] = true 




if (grid[state.row][state.col] == 'E') {
    {


if part == "1" {
    

 fmt.Println(distances[state])
    
} else {
    {


priors := previous[state]
 

i := 0
 


for (i < Slice_Len[State](priors)) {
    


for _, eg := range previous[priors[i]] {
    

priors = Slice_Append[State](priors, eg)  
} 


i = i + 1  
} 

dedup := Map_new[State, int]()
 

for _, eg := range priors {
    



 Map_Insert[State, int](dedup, State { row: eg.row, 
col: eg.col, 
facing: make_Dir_North(),  }, 1) 
} 

 fmt.Println(priors)

 fmt.Println(dedup)

 fmt.Println(Map_Len[State, int](dedup))
}
    
} 
break 
}
    
}  
var next_coord Tuple2[int, int]

 var13_subject := state.facing
var14_matches := 0



if var14_matches != 2 {
    var14_matches = 0

    var15_match_pat := 0

if var15_match_pat != 1 && var13_subject.tag == Dir_North {
    var14_matches = 2
} else {
    var14_matches = 1
}

    _ = var13_subject

    if var14_matches == 2 {
        


        next_coord =  Tuple2[int, int] { first: state.row - 1, 
second: state.col,  }
    }
}


if var14_matches != 2 {
    var14_matches = 0

    var16_match_pat := 0

if var16_match_pat != 1 && var13_subject.tag == Dir_East {
    var14_matches = 2
} else {
    var14_matches = 1
}

    _ = var13_subject

    if var14_matches == 2 {
        


        next_coord =  Tuple2[int, int] { first: state.row, 
second: state.col + 1,  }
    }
}


if var14_matches != 2 {
    var14_matches = 0

    var17_match_pat := 0

if var17_match_pat != 1 && var13_subject.tag == Dir_South {
    var14_matches = 2
} else {
    var14_matches = 1
}

    _ = var13_subject

    if var14_matches == 2 {
        


        next_coord =  Tuple2[int, int] { first: state.row + 1, 
second: state.col,  }
    }
}


if var14_matches != 2 {
    var14_matches = 0

    var18_match_pat := 0

if var18_match_pat != 1 && var13_subject.tag == Dir_West {
    var14_matches = 2
} else {
    var14_matches = 1
}

    _ = var13_subject

    if var14_matches == 2 {
        


        next_coord =  Tuple2[int, int] { first: state.row, 
second: state.col - 1,  }
    }
}
 

var19 := next_coord
next_row := var19.first
next_col := var19.second 



next_state := State { row: next_row, 
col: next_col, 
facing: state.facing,  }
 




if (grid[next_row][next_col] != '#') {
    

var22_result := func() Option[int] {
    var20_check, var21_err := Map_Get[State, int](distances, next_state)
    if var21_err == false {
        return make_Option_None[int]()
    }
    return make_Option_Some[int](var20_check)
}()

 var23_subject := var22_result
var24_matches := 0



if var24_matches != 2 {
    var24_matches = 0

    var25_match_pat := 0

if var25_match_pat != 1 && var23_subject.tag == Option_None {
    var24_matches = 2
} else {
    var24_matches = 1
}

    _ = var23_subject

    if var24_matches == 2 {
        {




 Map_Insert[State, int](distances, next_state, distances[state] + 1)


 Map_Insert[State, []State](previous, next_state, []State { state })


queue = Slice_Append[State](queue, next_state) 

_ = struct{}{} 
}
        
    }
}


if var24_matches != 2 {
    var24_matches = 0

    var26_match_pat := 0
score := var23_subject.Some

if var26_match_pat != 1 && var23_subject.tag == Option_Some {
    var24_matches = 2
} else {
    var24_matches = 1
}

    _ = var23_subject

    if var24_matches == 2 {
        



if score > distances[state] + 1 {
    {





distances[next_state] = distances[state] + 1 



previous[next_state] = []State { state } 
}
    
} else {
    



if score == distances[state] + 1 {
    




previous[next_state] = Slice_Append[State](previous[next_state], state) 
    
} else {
    
_ = struct{}{} 
    
}
    
} 
        
    }
}
 
    
}  
var left Dir

 var28_subject := state.facing
var29_matches := 0



if var29_matches != 2 {
    var29_matches = 0

    var30_match_pat := 0

if var30_match_pat != 1 && var28_subject.tag == Dir_North {
    var29_matches = 2
} else {
    var29_matches = 1
}

    _ = var28_subject

    if var29_matches == 2 {
        
        left =  make_Dir_West()
    }
}


if var29_matches != 2 {
    var29_matches = 0

    var31_match_pat := 0

if var31_match_pat != 1 && var28_subject.tag == Dir_East {
    var29_matches = 2
} else {
    var29_matches = 1
}

    _ = var28_subject

    if var29_matches == 2 {
        
        left =  make_Dir_North()
    }
}


if var29_matches != 2 {
    var29_matches = 0

    var32_match_pat := 0

if var32_match_pat != 1 && var28_subject.tag == Dir_South {
    var29_matches = 2
} else {
    var29_matches = 1
}

    _ = var28_subject

    if var29_matches == 2 {
        
        left =  make_Dir_East()
    }
}


if var29_matches != 2 {
    var29_matches = 0

    var33_match_pat := 0

if var33_match_pat != 1 && var28_subject.tag == Dir_West {
    var29_matches = 2
} else {
    var29_matches = 1
}

    _ = var28_subject

    if var29_matches == 2 {
        
        left =  make_Dir_South()
    }
}
 



next_state = State { row: state.row, 
col: state.col, 
facing: left,  }
 


var36_result := func() Option[int] {
    var34_check, var35_err := Map_Get[State, int](distances, next_state)
    if var35_err == false {
        return make_Option_None[int]()
    }
    return make_Option_Some[int](var34_check)
}()

 var37_subject := var36_result
var38_matches := 0



if var38_matches != 2 {
    var38_matches = 0

    var39_match_pat := 0

if var39_match_pat != 1 && var37_subject.tag == Option_None {
    var38_matches = 2
} else {
    var38_matches = 1
}

    _ = var37_subject

    if var38_matches == 2 {
        {




 Map_Insert[State, int](distances, next_state, distances[state] + 1000)


 Map_Insert[State, []State](previous, next_state, []State { state })


queue = Slice_Append[State](queue, next_state) 

_ = struct{}{} 
}
        
    }
}


if var38_matches != 2 {
    var38_matches = 0

    var40_match_pat := 0
score := var37_subject.Some

if var40_match_pat != 1 && var37_subject.tag == Option_Some {
    var38_matches = 2
} else {
    var38_matches = 1
}

    _ = var37_subject

    if var38_matches == 2 {
        



if score > distances[state] + 1 {
    {





distances[next_state] = distances[state] + 1000 



previous[next_state] = []State { state } 
}
    
} else {
    



if score == distances[state] + 1000 {
    




previous[next_state] = Slice_Append[State](previous[next_state], state) 
    
} else {
    
_ = struct{}{} 
    
}
    
} 
        
    }
}
 
var right Dir

 var42_subject := state.facing
var43_matches := 0



if var43_matches != 2 {
    var43_matches = 0

    var44_match_pat := 0

if var44_match_pat != 1 && var42_subject.tag == Dir_North {
    var43_matches = 2
} else {
    var43_matches = 1
}

    _ = var42_subject

    if var43_matches == 2 {
        
        right =  make_Dir_East()
    }
}


if var43_matches != 2 {
    var43_matches = 0

    var45_match_pat := 0

if var45_match_pat != 1 && var42_subject.tag == Dir_East {
    var43_matches = 2
} else {
    var43_matches = 1
}

    _ = var42_subject

    if var43_matches == 2 {
        
        right =  make_Dir_South()
    }
}


if var43_matches != 2 {
    var43_matches = 0

    var46_match_pat := 0

if var46_match_pat != 1 && var42_subject.tag == Dir_South {
    var43_matches = 2
} else {
    var43_matches = 1
}

    _ = var42_subject

    if var43_matches == 2 {
        
        right =  make_Dir_West()
    }
}


if var43_matches != 2 {
    var43_matches = 0

    var47_match_pat := 0

if var47_match_pat != 1 && var42_subject.tag == Dir_West {
    var43_matches = 2
} else {
    var43_matches = 1
}

    _ = var42_subject

    if var43_matches == 2 {
        
        right =  make_Dir_North()
    }
}
 



next_state = State { row: state.row, 
col: state.col, 
facing: right,  }
 


var50_result := func() Option[int] {
    var48_check, var49_err := Map_Get[State, int](distances, next_state)
    if var49_err == false {
        return make_Option_None[int]()
    }
    return make_Option_Some[int](var48_check)
}()

 var51_subject := var50_result
var52_matches := 0



if var52_matches != 2 {
    var52_matches = 0

    var53_match_pat := 0

if var53_match_pat != 1 && var51_subject.tag == Option_None {
    var52_matches = 2
} else {
    var52_matches = 1
}

    _ = var51_subject

    if var52_matches == 2 {
        {




 Map_Insert[State, int](distances, next_state, distances[state] + 1000)


 Map_Insert[State, []State](previous, next_state, []State { state })


queue = Slice_Append[State](queue, next_state) 

_ = struct{}{} 
}
        
    }
}


if var52_matches != 2 {
    var52_matches = 0

    var54_match_pat := 0
score := var51_subject.Some

if var54_match_pat != 1 && var51_subject.tag == Option_Some {
    var52_matches = 2
} else {
    var52_matches = 1
}

    _ = var51_subject

    if var52_matches == 2 {
        



if score > distances[state] + 1 {
    {





distances[next_state] = distances[state] + 1000 



previous[next_state] = []State { state } 
}
    
} else {
    



if score == distances[state] + 1000 {
    




previous[next_state] = Slice_Append[State](previous[next_state], state) 
    
} else {
    
_ = struct{}{} 
    
}
    
} 
        
    }
}
  
}  
}