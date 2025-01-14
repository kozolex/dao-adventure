export const idlFactory = ({ IDL }) => {
  const Member = IDL.Record({ 'age' : IDL.Nat, 'name' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Result_1 = IDL.Variant({ 'ok' : Member, 'err' : IDL.Text });
  const DAO = IDL.Service({
    'addMember' : IDL.Func([Member], [Result], []),
    'getAllMembers' : IDL.Func([], [IDL.Vec(Member)], ['query']),
    'getMember' : IDL.Func([IDL.Principal], [Result_1], ['query']),
    'numberOfMembers' : IDL.Func([], [IDL.Nat], ['query']),
    'removeMember' : IDL.Func([], [Result], []),
    'updateMember' : IDL.Func([Member], [Result], []),
  });
  return DAO;
};
export const init = ({ IDL }) => { return []; };
