import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface DAO {
  'addMember' : ActorMethod<[Member], Result>,
  'getAllMembers' : ActorMethod<[], Array<Member>>,
  'getMember' : ActorMethod<[Principal], Result_1>,
  'numberOfMembers' : ActorMethod<[], bigint>,
  'removeMember' : ActorMethod<[], Result>,
  'updateMember' : ActorMethod<[Member], Result>,
}
export interface Member { 'age' : bigint, 'name' : string }
export type Result = { 'ok' : null } |
  { 'err' : string };
export type Result_1 = { 'ok' : Member } |
  { 'err' : string };
export interface _SERVICE extends DAO {}
