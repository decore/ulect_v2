###*
* OperatorsController
*
* @author Nikolay Gerzhan <nikolay.gerzhan@gmail.com>
###
##TODO: delete demo OPERATORS
_demo_operators = [
    id:2
    username: "DEMO_Operator_N1"
    sid: "AC220dd9ec0df20b77d7cdd306ee34f43a"
,
    id:3
    username: "DEMO_Operator_N3"
    sid: "AC220dd9ec0df20b77d7cdd306ee34f43a"
]
module.exports = {
    index: (req,res)->

        return res.json _demo_operators
    ##active operators list
    find:  (req,res)->

        return res.json _demo_operators
}