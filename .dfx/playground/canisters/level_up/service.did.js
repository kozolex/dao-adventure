export const idlFactory = ({ IDL }) => {
  return IDL.Service({
    'counterInc' : IDL.Func([], [], ['oneway']),
    'getCounter' : IDL.Func([], [IDL.Nat], ['query']),
    'resetCounter' : IDL.Func([], [], ['oneway']),
  });
};
export const init = ({ IDL }) => { return []; };
