open System
open System.IO
open System.Collections.Generic

type Node = { 
  Id: string 
  Size: int 
}
type EdgeCounts = Dictionary<Node, int>
type AdjacencyList = Dictionary<Node, EdgeCounts>

let makeNode str : Node = 
  { Id = str; Size = 1 }
let mergeNodes a b : Node = 
  { Id = a.Id + "-" + b.Id; Size = a.Size + b.Size }

let addEdge (adjList: AdjacencyList) (a: Node) (b: Node) =
  let edgeCounts =
    match adjList.TryGetValue(a) with
    | true, counts -> counts
    | _ -> EdgeCounts()
  let currentCount =
    match edgeCounts.TryGetValue(b) with
    | true, count -> count
    | _ -> 0
  edgeCounts.[b] <- currentCount + 1
  adjList.[a] <- edgeCounts

let mergeEdgeCounts (a: EdgeCounts) (b: EdgeCounts) : EdgeCounts =
  for edge in b do
    let nextWeight =
      match a.TryGetValue(edge.Key) with
      | true, weight -> weight + edge.Value
      | _ -> edge.Value
    a.[edge.Key] <- nextWeight
  a

let parseLine (adjList: AdjacencyList) (line: string) =
  match line.Split(':') with
  | [| src; destStr |] ->
    let srcNode = makeNode src
    destStr.Trim().Split(' ') |> Seq.iter (fun dest ->
      let destNode = makeNode dest
      addEdge adjList srcNode destNode
      addEdge adjList destNode srcNode)
  | _ -> failwith "Invalid line"

let buildAdjacencyList filename =
  let adjList = AdjacencyList()
  let lines = File.ReadAllLines(filename)
  lines |> Array.iter (parseLine adjList)
  adjList

let mergeInList (adjList: AdjacencyList) (a: Node) (b: Node) : AdjacencyList =
  let mergedNode = mergeNodes a b
  let mergedEdges = mergeEdgeCounts adjList.[a] adjList.[b]
  adjList.[mergedNode] <- mergedEdges
  adjList.Remove(a) |> ignore
  adjList.Remove(b) |> ignore
  mergedEdges.Remove(a) |> ignore
  mergedEdges.Remove(b) |> ignore
  for elem in mergedEdges do
    let edges = adjList[elem.Key]
    let priorAWeight =
      match edges.TryGetValue(a) with
      | (true, weight) -> weight
      | _ -> 0
    let priorBWeight =
      match edges.TryGetValue(b) with
      | (true, weight) -> weight
      | _ -> 0
    edges.Remove(a) |> ignore
    edges.Remove(b) |> ignore
    edges.[mergedNode] <- priorAWeight + priorBWeight
  adjList

let random = new Random()

let pickRandomKey (dict: IDictionary<_, _>) =
  let keys = dict.Keys |> Seq.toArray
  let index = random.Next(keys.Length)
  keys.[index]

let contract (adjList: AdjacencyList) : AdjacencyList =
  while adjList.Count > 2 do
    let a = pickRandomKey adjList
    let b = pickRandomKey adjList.[a]
    (mergeInList adjList a b) |> ignore
  adjList

let deepCopy (srcList: AdjacencyList) : AdjacencyList =
  let newList = AdjacencyList()
  for pair in srcList do
    let node = { pair.Key with Size = pair.Key.Size }
    let edgeCounts = EdgeCounts(pair.Value)
    newList.Add(node, edgeCounts)
  newList

let rec findmincut (srcList: AdjacencyList) : AdjacencyList =
  let adjList = contract(deepCopy srcList)
  let nodes = adjList |> Seq.take 2 |> Seq.toArray
  if adjList.[nodes.[0].Key].[nodes.[1].Key] = 3 then
    adjList
  else
    findmincut srcList

let args = fsi.CommandLineArgs
let inputFile = args.[1]
let part = args.[2]
let adjacencyList = buildAdjacencyList inputFile
let minAdjacencyList = findmincut adjacencyList
let product = minAdjacencyList |> Seq.map (fun node -> node.Key.Size) |> Seq.fold (*) 1
printfn "%d" product
