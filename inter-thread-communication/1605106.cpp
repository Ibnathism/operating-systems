#include <iostream>
#include <cstdio>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>
#include <cstring>
#include <time.h>
#include <chrono>
#include <thread>
#include <queue>

using namespace std;

#define S 3
#define C 2
#define number_of_cycles 10
sem_t service_capacity_sem, service_currentItems_sem;
sem_t payment_capacity_sem, payment_currentItems_sem;
pthread_mutex_t servicemen_mutex[S];
pthread_mutex_t direction_mutex;

pthread_mutex_t N, L;

void depart(void *arg)
{
    pthread_mutex_lock(&N);
    for (int i = 0; i < S; i++)
    {
        pthread_mutex_lock(&servicemen_mutex[i]);
    }
    pthread_mutex_unlock(&N);

    sem_wait(&service_capacity_sem);
    sem_post(&service_currentItems_sem);

    printf("%s has departed\n", (char *)arg);
    fflush(stdout);
    sem_wait(&service_currentItems_sem);
    sem_post(&service_capacity_sem);

    for (int i = 0; i < S; i++)
    {
        pthread_mutex_unlock(&servicemen_mutex[i]);
    }
}
void leave_payment_room(void *arg)
{
    sem_wait(&payment_currentItems_sem);
    int random = rand() % 100 + 1;
    this_thread::sleep_for(chrono::milliseconds(random));
    printf("%s finished paying the service bill\n", (char *)arg);
    fflush(stdout);

    sem_post(&payment_capacity_sem);

    depart(arg);
}
void go_to_payment_room(void *arg)
{

    sem_post(&service_capacity_sem);

    sem_wait(&payment_capacity_sem);
    printf("%s started paying the service bill\n", (char *)arg);
    fflush(stdout);
    sem_post(&payment_currentItems_sem);

    leave_payment_room(arg);
}
void change_room(int i, void *arg)
{
    if (i == 1)
    {
        sem_post(&service_currentItems_sem); //up
    }
    if (i == S)
    {
        int random = rand() % 100 + 1;
        this_thread::sleep_for(chrono::milliseconds(random));
        printf("%s finished taking service from serviceman %d\n", (char *)arg, i - 1 + 1);
        fflush(stdout);
        pthread_mutex_unlock(&servicemen_mutex[i - 1]);

        pthread_mutex_unlock(&L);

        sem_wait(&service_currentItems_sem);

        go_to_payment_room(arg);
        return;
    }
    pthread_mutex_lock(&servicemen_mutex[i]);

    int random = rand() % 100 + 1;
    this_thread::sleep_for(chrono::milliseconds(random));
    printf("%s finished taking service from serviceman %d\n", (char *)arg, i - 1 + 1);
    fflush(stdout);
    printf("%s started taking service from serviceman %d\n", (char *)arg, i + 1);
    fflush(stdout);

    pthread_mutex_unlock(&servicemen_mutex[i - 1]);

    change_room(i + 1, arg);
}
void *enter_service_room(void *arg)
{
    pthread_mutex_lock(&L);
    pthread_mutex_lock(&N);

    sem_wait(&service_capacity_sem); //down
    pthread_mutex_lock(&servicemen_mutex[0]);

    pthread_mutex_unlock(&N);

    printf("%s started taking service from serviceman 1\n", (char *)arg);
    fflush(stdout);

    change_room(1, arg);
}

int main(int argc, char *argv[])
{
    int res;

    res = sem_init(&service_capacity_sem, 0, S);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = sem_init(&service_currentItems_sem, 0, 0);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = sem_init(&payment_capacity_sem, 0, C);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = sem_init(&payment_currentItems_sem, 0, 0);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = pthread_mutex_init(&direction_mutex, NULL);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = pthread_mutex_init(&N, NULL);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    res = pthread_mutex_init(&L, NULL);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }

    for (int i = 0; i < S; i++)
    {
        res = pthread_mutex_init(&servicemen_mutex[i], NULL);
        if (res != 0)
        {
            printf("Failed\n");
            fflush(stdout);
        }
    }

    pthread_t customers[number_of_cycles];
    for (int i = 0; i < number_of_cycles; i++)
    {
        char *id = new char[3];
        strcpy(id, to_string(i + 1).c_str());

        res = pthread_create(&customers[i], NULL, enter_service_room, (void *)id);

        if (res != 0)
        {
            printf("Thread creation failed\n");
            fflush(stdout);
        }
    }

    for (int i = 0; i < number_of_cycles; i++)
    {
        void *result;
        pthread_join(customers[i], &result);
    }

    res = sem_destroy(&service_capacity_sem);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = sem_destroy(&service_currentItems_sem);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = sem_destroy(&payment_capacity_sem);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = sem_destroy(&payment_currentItems_sem);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = pthread_mutex_destroy(&direction_mutex);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = pthread_mutex_destroy(&N);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    res = pthread_mutex_destroy(&L);
    if (res != 0)
    {
        printf("Failed\n");
        fflush(stdout);
    }
    for (int i = 0; i < S; i++)
    {
        res = pthread_mutex_destroy(&servicemen_mutex[i]);
        if (res != 0)
        {
            printf("Failed\n");
            fflush(stdout);
        }
    }

    return 0;
}