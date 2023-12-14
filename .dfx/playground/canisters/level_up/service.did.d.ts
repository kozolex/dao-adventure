import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface _SERVICE {
  'counterInc' : ActorMethod<[], undefined>,
  'getCounter' : ActorMethod<[], bigint>,
  'resetCounter' : ActorMethod<[], undefined>,
}
