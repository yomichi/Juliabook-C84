require("point.jl")
using RW
using ArgParse

function parse_commandline()
  settings = ArgParseSettings()
  settings.add_help = false
  @add_arg_table settings begin
    "--num", "-n"
      help = "ウォーカー数 NUM (>0) を指定します。"
      arg_type = Int
      default = 1024
      range_tester = n-> n>0
    "--steps", "-s"
      help = "実行ステップ数 STEPS (>0) を指定します。"
      arg_type = Int
      default = 1024
      range_tester = t-> t>0
    "--dim", "-d"
      help = "空間次元 dim (0<d<4) を指定します。"
      arg_type = Int
      default = 1
      range_tester = d -> 0 < d < 4
    "--continuous", "-c"
      help = "連続空間上のランダムウォークを行います。" *
             "各ステップの差分は半径1 のd次元球面から一様ランダムに選ばれます。"
      action = :store_true
    "--output", "-o"
      help = "出力ファイル名を指定します。" *
             "空の場合、標準出力を使用します。"
      arg_type = String
      default = ""
    "--help", "-h"
      help = "このヘルプメッセージを表示して、終了します。"
      action = :show_help
  end
  return parse_args(settings)
end

function main()
  pargs = parse_commandline()

  N  = pargs["num"]
  T  = pargs["steps"]
  d  = pargs["dim"]

  if d == 1
    PT = pargs["continuous"]?CPoint1D{Float64}:DPoint1D{Float64}
  elseif d == 2
    PT = pargs["continuous"]?CPoint2D{Float64}:DPoint2D{Float64}
  else
    PT = pargs["continuous"]?CPoint3D{Float64}:DPoint3D{Float64}
  end

  filename = pargs["output"]
  if length(filename) == 0
    output = STDOUT
  else
    output = open(filename, "w")
  end

  write(output, "# 1 : number of steps \n")
  write(output, "# 2 : norm of mean of points \n")
  write(output, "# 3 : mean of norm^2 of points \n")
  write(output, "# 4 : min of norm of points \n")
  write(output, "# 5 : max of norm of points \n")
  write(output, "# 6-: coordinates of mean of points \n")
  write(output, "\n")

  ps = zeros(PT,N)
  for t in 0:T
    m = mean(ps)
    n2s = map(norm2,ps)
    write(output, "$t " * 
                  "$( norm(m) ) " *
                  "$( mean(n2s) ) " *
                  "$( sqrt(min(n2s)) ) " *
                  "$( sqrt(max(n2s)) ) " *
                  "$( to_plot_str(m) ) " *
                  "\n")
    update!(ps)
  end

  close(output)
end

main()

