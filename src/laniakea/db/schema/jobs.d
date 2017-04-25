/*
 * Copyright (C) 2017 Matthias Klumpp <matthias@tenstral.net>
 *
 * Licensed under the GNU Lesser General Public License Version 3
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the license, or
 * (at your option) any later version.
 *
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this software.  If not, see <http://www.gnu.org/licenses/>.
 */

module laniakea.db.schema.jobs;
@safe:

import vibe.db.mongo.mongo;
import vibe.data.serialization : name;

import laniakea.db.schema.basic;

/**
 * Type of the particular job.
 **/
enum JobMode
{
    UNKNOWN,
    ONESHOT,
    PERIODIC
}

/**
 * State this job is in.
 **/
enum JobStatus
{
    UNKNOWN,
    WAITING,   // waiting for someone to take the job
    SCHEDULED, // job has been assigned,
    RUNNING,
    DONE,
    STARVING   // the job was left abandoned for too long
}

/**
 * Result of a job.
 **/
enum JobResult
{
    UNKNOWN,
    SUCCESS,
    FAILURE
}

/**
 * A task pending to be performed.
 **/
template Job(LkModule mod, string jobKind) {
    @name("_id") BsonObjectID id;

    JobMode mode;     /// Type of the job
    JobStatus status; /// Status of this job

    @name("module") string moduleName = mod; /// the name of the module responsible for this job
    string kind = jobKind; /// kind of the job

    string title;     /// A human-readable title of this job

    string trigger;   /// System responsible for triggering this job's creation

    BsonDate createdTime;  /// Time when this job was created.
    BsonDate assignedTime; /// Time when this job was assigned to a worker.
    BsonDate finishedTime; /// Time when this job was finished.

    string worker;    /// The person/system/tool this job is assigned to
    string workerId;  /// Unique ID of the entity the job is assigned to

    string latestLogExcerpt;   /// An excerpt of the current job log

    JobResult result;
}

/**
 * Type of an incident.
 **/
enum EventKind
{
    UNKNOWN,
    INFO,
    WARNING,
    ERROR,
    CRITICAL
}

/**
 * An event log entry.
 **/
struct EventEntry {
    @name("_id") BsonObjectID id;

    EventKind kind;     // Type of this event
    @name("module") string moduleName; // the name of the module responsible for this event
    BsonDate time;  // Time when this issue was created.

    string title;     // A human-readable title of this issue
    string content;   // content of this issue
}