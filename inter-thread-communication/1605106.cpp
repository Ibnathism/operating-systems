#include <iostream>
#include <cstdio>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>
#include <cstring>
#include <time.h>

using namespace std;

#define service_room_capacity 3
#define payment_room_capacity 2
#define number_of_cycles 10

// Shared Resource #1: Service Room
// Producer: People entering into the service room (Either from entrance / from payment room)
// Consumer: People exiting from service room to payment room

// Shared Resource #2: Payment Room
// Producer: People entering to payment room after finishing service
// Consumer: People exiting from payment room to service room

// So, Consumer of #1 is basically the Producer of #2

// F1 = Entrance -> Service Room
// F2 = Room changing inside Service Room (Left to Right)
// F3 = Service -> Payment
// F4 = Payment -> Service
// F5 = departure

// Constraints:       1. if service_room_capacity full, ENTRY PROHIBITED from left
//                    2. if there's anyone left->right direction person inside service room, ENTRY PROHIBITED from right
//                    3. if there's anyone right->left direction person inside service room, ENTRY PROHIBITED from left
//                    4. if there's anyone in the path "payment->service", ENTRY PROHIBITED from left to service room
//                    5. if payment_room_capacity full, ENTRY PROHIBITED from left
//                    6. A service can contain only one cycle at a time
//                    7. Payment ready means incoming service off
