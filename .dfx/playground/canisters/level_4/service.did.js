export const idlFactory = ({ IDL }) => {
  const Member = IDL.Record({ 'age' : IDL.Nat, 'name' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : IDL.Null, 'err' : IDL.Text });
  const Subaccount = IDL.Vec(IDL.Nat8);
  const Account = IDL.Record({
    'owner' : IDL.Principal,
    'subaccount' : IDL.Opt(Subaccount),
  });
  const CreateProposalOk = IDL.Nat;
  const CreateProposalErr = IDL.Variant({
    'NotDAOMember' : IDL.Null,
    'NotEnoughTokens' : IDL.Null,
  });
  const createProposalResult = IDL.Variant({
    'ok' : CreateProposalOk,
    'err' : CreateProposalErr,
  });
  const Result_1 = IDL.Variant({ 'ok' : Member, 'err' : IDL.Text });
  const Status = IDL.Variant({
    'Open' : IDL.Null,
    'Rejected' : IDL.Null,
    'Accepted' : IDL.Null,
  });
  const Proposal = IDL.Record({
    'id' : IDL.Nat,
    'status' : Status,
    'votes' : IDL.Int,
    'voters' : IDL.Vec(IDL.Principal),
    'manifest' : IDL.Text,
  });
  const VoteOk = IDL.Variant({
    'ProposalOpen' : IDL.Null,
    'ProposalRefused' : IDL.Null,
    'ProposalAccepted' : IDL.Null,
  });
  const VoteErr = IDL.Variant({
    'AlreadyVoted' : IDL.Null,
    'ProposalEnded' : IDL.Null,
    'ProposalNotFound' : IDL.Null,
    'NotDAOMember' : IDL.Null,
    'NotEnoughTokens' : IDL.Null,
  });
  const voteResult = IDL.Variant({ 'ok' : VoteOk, 'err' : VoteErr });
  const DAO = IDL.Service({
    'addGoal' : IDL.Func([IDL.Text], [], []),
    'addMember' : IDL.Func([Member], [Result], []),
    'balanceOf' : IDL.Func([Account], [IDL.Nat], ['query']),
    'createProposal' : IDL.Func([IDL.Text], [createProposalResult], []),
    'getAllMembers' : IDL.Func([], [IDL.Vec(Member)], ['query']),
    'getGoals' : IDL.Func([], [IDL.Vec(IDL.Text)], ['query']),
    'getManifesto' : IDL.Func([], [IDL.Text], ['query']),
    'getMember' : IDL.Func([IDL.Principal], [Result_1], ['query']),
    'getName' : IDL.Func([], [IDL.Text], ['query']),
    'getProposal' : IDL.Func([IDL.Nat], [IDL.Opt(Proposal)], ['query']),
    'mint' : IDL.Func([IDL.Principal, IDL.Nat], [], []),
    'numberOfMembers' : IDL.Func([], [IDL.Nat], ['query']),
    'removeMember' : IDL.Func([], [Result], []),
    'setManifesto' : IDL.Func([IDL.Text], [], []),
    'tokenName' : IDL.Func([], [IDL.Text], ['query']),
    'tokenSymbol' : IDL.Func([], [IDL.Text], ['query']),
    'totalSupply' : IDL.Func([], [IDL.Nat], ['query']),
    'transfer' : IDL.Func([Account, Account, IDL.Nat], [Result], []),
    'updateMember' : IDL.Func([Member], [Result], []),
    'vote' : IDL.Func([IDL.Nat, IDL.Bool], [voteResult], []),
    'whoami' : IDL.Func([], [IDL.Principal], ['query']),
  });
  return DAO;
};
export const init = ({ IDL }) => { return []; };
