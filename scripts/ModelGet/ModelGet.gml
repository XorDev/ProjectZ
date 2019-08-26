/// @desc ModelGet(name / id);
/// @arg name
switch( argument_count == 1 ? typeof(argument[0]) : -1 ) {
    case "number": return global.m_map[? global.m_list[| argument[0]]];
    case "string": return global.m_map[? argument[0]];
    case -1      : return -1;
    default:       return global.m_list[| 0];;
}
