/*
Program to generate a report on the students having the top CGPAs
***************************************************************
* Author Dept. Date Notes
***************************************************************
* Doris Lu Wang Comp. Science. April 8 2021 Initial version.
* Doris Lu Wang Comp. Science. April 10 2021 Fix bug.
* Doris Lu Wang Comp. Science. April 13 2021 Added comment.
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * prints out usage
 */
void usage() {
    printf("Usage: ./topcgpas <sourcecsv> <outputcsv>\n");
    exit(1);
}

typedef struct StudentRecord {
    int64_t
        sid;  // whereas "long" is 64-bit on Linux it may not be 64 bits on all
              // platforms, so we use int64_t for cross-platform compatibility
    char email[30];
    char lname[20];
    char fname[20];
    float cgpa;
    struct StudentRecord* next;
} StudentRecord;

/**
 * wrapper around malloc to handle errors
 *
 * @INPUT size: bytes to allocate
 * @OUTPUT a: pointer to allocated memory
 */
void* safe_malloc(size_t size) {
    void* a = malloc(size);
    if (!a) {
        printf("Error! program ran out of memory\n");
        exit(1);
    }
    return a;
}

/**
 * delete the rest of a linked list after a given head node
 *
 * @INPUT head: the node after which everything will be deleted
 */
void delete_list(StudentRecord* head) {
    while (head && head->next) {
        StudentRecord* tmp = head->next;
        head->next = head->next->next;
        free(tmp);
    }
}

/**
 * keep the top n nodes by cgpa.
 * if there are multiple nodes with the same cgpa as the fifth,
 * keep them.
 *
 * @INPUT n: the top n to keep
 */
void prune_list(StudentRecord* head, ssize_t n) {
    for (int i = 0; i < n - 1 && head; head = head->next, i++) {
        if (!head->next) return;
    }
    if (head) {
        for (float cgpa_n = head->cgpa;
             head && head->next && head->next->cgpa == cgpa_n;
             head = head->next) {
        };
        delete_list(head);
    }
}

/**
 * insert a record into the linked list preserving the descending order
 *
 * @INPUT head: pointer to first node of the linked list
 * @INPUT record: pointer to node to insert
 * @OUTPUT head: pointer to first node of the linked list after node inserted
 */
StudentRecord* insert_list(StudentRecord* head, StudentRecord* record) {
    if (!head) {
        return record;
    }
    if (head->cgpa < record->cgpa) {
        record->next = head;
        head = record;
    } else {
        StudentRecord* item = head;
        for (; item; item = item->next) {
            if (!item->next || item->next->cgpa < record->cgpa) {
                record->next = item->next;
                item->next = record;
                break;
            }
        }
    }
    return head;
}

/**
 * print out linked list, e.g. print_list(head, stderr) to debug
 * or you can print it out to a file
 *
 * @INPUT head: pointer to first node of the linked list
 * @INPUT stream: stream to write the output
 */
void print_list(StudentRecord* head, FILE* stream) {
    fprintf(stream, "sid,email,cgpa\n");
    for (; head; head = head->next) {
        fprintf(stream, "%lld,%s,%f\n", head->sid, head->email, head->cgpa);
    }
}

/**
 * read file into a linked list of the top 5 ish students
 *
 * @INPUT input_file: file pointer to csv
 * @OUTPUT head: pointer to first node of linked list
 */
StudentRecord* read_list(FILE* input_file) {
    char* line = NULL;
    size_t len = 0;
    ssize_t nread;
    size_t lines_read = 0;
    StudentRecord* head = NULL;
    while ((nread = getline(&line, &len, input_file)) != -1) {
        if (lines_read) {
            StudentRecord* record = safe_malloc(sizeof(StudentRecord));
            record->next = NULL;
            sscanf(line, "%lld,%[^,],%[^,],%[^,],%f", &(record->sid),
                   record->email, record->lname, record->fname,
                   &(record->cgpa));
            head = insert_list(head, record);
            prune_list(head, 5);
        }  // else assume the first line is always the same
        lines_read++;
    }
    return head;
}

int main(int argc, char** argv) {
    if (argc != 3) {
        usage();
    }

    FILE* input_file = fopen(argv[1], "r");
    if (!input_file) {
        printf("Error! Unable to open the input file %s", argv[1]);
        return 1;
    }
    FILE* output_file = fopen(argv[2], "w");
    if (!output_file) {
        printf("Error! Unable to open the output file %s", argv[2]);
        return 1;
    }
    StudentRecord* head = read_list(input_file);
    if (!head) {
        printf("Error! Input CSV file %s is empty", argv[1]);
        return 1;
    }
    print_list(head, output_file);
    return 0;
}
